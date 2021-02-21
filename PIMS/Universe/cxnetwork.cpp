#include "cxnetwork.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QHttpMultiPart>
#include <QHttpPart>
#include <QJsonObject>
#include <QJSValueIterator>
#include <QUrlQuery>
#include <QFile>
#include <QFileInfo>
#include <QMimeDatabase>
#include <QDir>
#include <QStandardPaths>

namespace {
QString verbString(const CxNetwork::Verbs verb) {
    if (verb == CxNetwork::POST) {
        return QString("POST");
    } else if (verb == CxNetwork::DELETE || verb == CxNetwork::DELETE2) {
        return QString("DELETE");
    } else if (verb == CxNetwork::GET) {
        return QString("GET");
    } else if (verb == CxNetwork::PUT) {
        return QString("PUT");
    } else if (verb == CxNetwork::PATCH) {
        return QString("PATCH");
    }
    return QString();
}
}

CxNetwork::CxNetwork(QObject *parent)
    : QObject(parent)
    , m_networkAccessMgr(new QNetworkAccessManager(this))
{
    QObject::connect(m_networkAccessMgr, SIGNAL(sslErrors(QNetworkReply*,QList<QSslError> )),
                     this, SLOT(sslErrors(QNetworkReply*,QList<QSslError>)));

}

CxNetwork::~CxNetwork()
{
    if (m_sslErr) {
        delete m_sslErr;
        m_sslErr = nullptr;
    }
}

void CxNetwork::enableHttps(bool enabled)
{
    if (enabled && !m_sslErr) {
        QFile file("F:/me/perms/ca.crt");
        if (file.open(QIODevice::ReadOnly)) {
            const QByteArray bytes = file.readAll();
            const QSslCertificate certificate(bytes);
            m_sslErr = new QSslError(QSslError::SelfSignedCertificate, certificate);
        } else {
            m_sslErr = new QSslError(QSslError::SelfSignedCertificate);
        }
    } else if (!enabled && m_sslErr) {
        delete m_sslErr;
        m_sslErr = nullptr;
    }

}

void CxNetwork::post(const QUrl &url, const QJSValue &header, const QJSValue &body, const QJSValue &handler)
{
    request(Verbs::POST, url, header, body, handler);
}

void CxNetwork::get(const QUrl &url, const QJSValue &header, const QJSValue &handler)
{
    request(Verbs::GET, url, header, QJSValue(), handler);
}

void CxNetwork::put(const QUrl &url, const QJSValue &header, const QJSValue &body, const QJSValue &handler)
{
    request(Verbs::PUT, url, header, body, handler);
}

void CxNetwork::patch(const QUrl &url, const QJSValue &header, const QJSValue &body, const QJSValue &handler)
{
    request(Verbs::PATCH, url, header, body, handler);
}

void CxNetwork::del(const QUrl &url, const QJSValue &header, const QJSValue &handler)
{
    request(Verbs::DELETE, url, header, QJSValue(), handler);
}

void CxNetwork::del2(const QUrl &url, const QJSValue &header, const QJSValue &body, const QJSValue &handler)
{
    request(Verbs::DELETE2, url, header, body, handler);
}

void CxNetwork::upload(const QUrl &url, const QJSValue &header, const QJSValue &resList, const QJSValue &handler)
{
    qDebug() << "param:" << resList.toVariant();
    qDebug() << QString("[%1]").arg(::verbString(Verbs::POST)) << url.toString();
    const QStringList ress = resList.toVariant().toStringList();
    if (ress.length() <= 0) {
        if (handler.isCallable()) {
            QJSValue calle(handler);
            calle.call(QJSValueList{QJSValue()});
        }
        return;
    }

    QNetworkRequest req = newRequest(url, header);
    QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
    req.setHeader(QNetworkRequest::ContentTypeHeader, QString("multipart/form-data; boundary=%1").arg(QString(multiPart->boundary())));

    QFile f;
    QMimeDatabase mimeDB;
    for (const QString &res: ress) {
        QUrl url(res);
#if defined(Q_OS_WIN32)
        QString resPath = url.path();
        if (resPath.startsWith("/")) {
            resPath.remove(0,1);
        }
#else
        const QString resPath = url.path();
#endif
        if (!QFileInfo::exists(resPath)) { continue; }
        f.setFileName(resPath);
        if (!f.open(QFile::ReadOnly)) { continue; }

        QFileInfo info(f);
        QMimeType mime = mimeDB.mimeTypeForFile(info);
        qDebug() << resPath << info.fileName() << ":" << mime.name();

        QHttpPart part;
        part.setHeader(QNetworkRequest::ContentTypeHeader, mime.name());
        part.setHeader(QNetworkRequest::ContentDispositionHeader,
                       QVariant(QString(R"(form-data; name="uploads"; filename="%1")").arg(info.fileName())));
        part.setBodyDevice(nullptr);
        part.setBody(f.readAll());
        f.close();

        multiPart->append(part);
    }

    QNetworkReply *reply = m_networkAccessMgr->post(req, multiPart);
    if (reply) {
        multiPart->setParent(reply);

        if (handler.isCallable()) {
            m_responseHanlders.insert(reply, handler);
            connect(reply, SIGNAL(finished()), this, SLOT(onReply()));
        }
    } else {
        multiPart->deleteLater();
    }
}

void CxNetwork::download(const QUrl &url, const QJSValue &header, const QString &query, const QJSValue &handler)
{
    qDebug() << QString("[%1]").arg(::verbString(Verbs::GET)) << url.toString();

    QUrlQuery urlQuery(url);
    const QString value = QFileInfo(urlQuery.queryItemValue(query)).fileName();

    QNetworkRequest req = newRequest(url, header);
    QNetworkReply *reply = m_networkAccessMgr->get(req);
    if (reply) {
        QObject::connect(reply, &QNetworkReply::finished, this, [&reply, handler, value](){
            QDir dir(QStandardPaths::displayName(QStandardPaths::AppDataLocation));
            if (!dir.exists()) {
                dir.mkpath("res");
            }

            const QString filePath = dir.absoluteFilePath(value);
            QFile f(filePath);

            if (f.open(QFile::WriteOnly)) {
                f.write(reply->readAll());
                f.flush();
                f.close();
            }

            QJSValue h = handler;
            if (h.isCallable()) {
                h.call(QJSValueList() << QJSValue(filePath));
            }

            reply->deleteLater();
        });
    }
}

void CxNetwork::onReply()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply || !m_responseHanlders.contains(reply)) {
        return;
    }

    qDebug() << "REPLY:"
    << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt()
    << reply->url().toString();

    QJSValue handler = m_responseHanlders.take(reply);
    if (handler.isCallable()) {
        handler.call(QJSValueList() << QJSValue(QString(reply->readAll())));
    }
}

void CxNetwork::sslErrors(QNetworkReply *reply, QList<QSslError> errs)
{
    Q_UNUSED(errs)
    reply->ignoreSslErrors();
}

QNetworkRequest CxNetwork::newRequest(const QUrl &url, const QJSValue &header)
{
    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");

    if (m_firstReq && m_sslErr) {
        m_firstReq = false;

        QSslConfiguration conf = req.sslConfiguration();
        conf.setProtocol(QSsl::TlsV1SslV3);
        conf.setPeerVerifyMode(QSslSocket::VerifyPeer);
        if (!m_sslErr->certificate().isNull()) {
            conf.addCaCertificate(m_sslErr->certificate());
        }
        req.setSslConfiguration(conf);
    }

    QJSValueIterator iter(header);
    while (iter.hasNext()) {
        iter.next();
        const QByteArray headerName = iter.name().toUtf8();
        if (headerName.isEmpty()) { continue; }
        QByteArray headerValue;
        if (headerName == QStringLiteral("Authorization")) {
            headerValue.append("Basic ");
            const QString value = iter.value().toString();
            headerValue.append(value.toUtf8().toBase64());
        }
        req.setRawHeader(headerName,headerValue);
    }

    return req;
}

void CxNetwork::request(Verbs verb, const QUrl &url, const QJSValue &header, const QJSValue &body, const QJSValue &handler)
{
    qDebug() << QString("[%1]").arg(::verbString(verb)) << url.toString();

    QNetworkRequest req = newRequest(url, header);

    QByteArray bodyBytes;
    if (!body.isUndefined() && !body.isNull()) {
        QJsonDocument doc = QJsonDocument::fromVariant(body.toVariant());
        bodyBytes = doc.toJson(QJsonDocument::Compact);
    }

    QNetworkReply *reply = nullptr;
    if (verb == Verbs::POST) {
        reply = m_networkAccessMgr->post(req, bodyBytes);
    } else if (verb == Verbs::DELETE) {
        reply = m_networkAccessMgr->deleteResource(req);
    } else if (verb == Verbs::DELETE2) {
        reply = m_networkAccessMgr->sendCustomRequest(req, QByteArray("DELETE"), bodyBytes);
    } else if (verb == Verbs::GET) {
        reply = m_networkAccessMgr->get(req);
    } else if (verb == Verbs::PUT) {
        reply = m_networkAccessMgr->put(req, bodyBytes);
    } else if (verb == Verbs::PATCH) {
        reply = m_networkAccessMgr->sendCustomRequest(req, QByteArray("PATCH"), bodyBytes);
    } else {
        qDebug() << "Not supported verb:" << verb << ". Current support: [POST, DELETE, GET, PUT, PATCH].";
        return;
    }

    if (reply && handler.isCallable()) {
        m_responseHanlders.insert(reply, handler);
        connect(reply, SIGNAL(finished()), this, SLOT(onReply()));
    }
}
