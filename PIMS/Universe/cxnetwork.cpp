#include "cxnetwork.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QHttpMultiPart>
#include <QHttpPart>
#include <QJsonObject>
#include <QJSValueIterator>
#include <QFile>
#include <QFileInfo>

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

void CxNetwork::upload(const QUrl &url, const QJSValue &header, const QStringList &resList, const QJSValue &handler)
{
    qDebug() << QString("[%1]").arg(::verbString(Verbs::POST)) << url.toString();
    QNetworkRequest req = newRequest(url, header);

    QFile f;
    for (const QString &res: resList) {
        if (!QFileInfo::exists(res)) { continue; }

        f.setFileName(res);
        if (!f.open(QFile::ReadOnly)) { continue; }

        QHttpPart part;
        part.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("application/"));
        part.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"uploads\""));
        part.setBodyDevice(&f);

        f.close();
    }

    QHttpMultiPart *multiParty = new QHttpMultiPart(QHttpMultiPart::FormDataType);

    QNetworkReply *reply = m_networkAccessMgr->post(req, multiParty);
    multiParty->setParent(reply);

    if (reply && handler.isCallable()) {
        m_responseHanlders.insert(reply, handler);
        connect(reply, SIGNAL(finished()), this, SLOT(onReply()));
    }
}

void CxNetwork::onReply()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply || !m_responseHanlders.contains(reply)) {
        return;
    }

//    qDebug() << "STATUS:" << reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();

    qDebug() << "REPLY:" << reply->operation() << reply->url().toString();
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
