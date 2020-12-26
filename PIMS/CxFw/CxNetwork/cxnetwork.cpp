#include "cxnetwork.h"
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>

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

void CxNetwork::post(const QUrl &url, const QJSValue &body, const QJSValue &handler)
{
    qDebug() << "[POST]" << url.toString();

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

    QJsonDocument doc = QJsonDocument::fromVariant(body.toVariant());
    QNetworkReply *reply = m_networkAccessMgr->post(req, doc.toJson(QJsonDocument::Compact));
    m_responseHanlders.insert(reply, handler);
    connect(reply, SIGNAL(finished()), this, SLOT(onReply()));
}

void CxNetwork::get(const QUrl &url, const QJSValue &handler)
{
    qDebug() << "[GET]" << url.toString();

    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");

    if (m_firstReq && m_sslErr) {
        m_firstReq = false;

        QSslConfiguration conf = req.sslConfiguration();
        conf.setProtocol(QSsl::TlsV1SslV3);
        conf.setPeerVerifyMode(QSslSocket::VerifyPeer);
        conf.addCaCertificate(m_sslErr->certificate());
        req.setSslConfiguration(conf);
    }

    QNetworkReply *reply = m_networkAccessMgr->get(req);
    m_responseHanlders.insert(reply, handler);
    connect(reply, SIGNAL(finished()), this, SLOT(onReply()));
}

void CxNetwork::put(const QUrl &url, const QJSValue &body, const QJSValue &handler)
{
    qDebug() << "[PUT]" << url.toString();

    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");

    if (m_firstReq && m_sslErr) {
        m_firstReq = false;

        QSslConfiguration conf = req.sslConfiguration();
        conf.setProtocol(QSsl::TlsV1SslV3);
        conf.setPeerVerifyMode(QSslSocket::VerifyPeer);
        conf.addCaCertificate(m_sslErr->certificate());
        req.setSslConfiguration(conf);
    }

    QJsonDocument doc = QJsonDocument::fromVariant(body.toVariant());
    QNetworkReply *reply = m_networkAccessMgr->put(req, doc.toJson(QJsonDocument::Compact));
    m_responseHanlders.insert(reply, handler);
    connect(reply, SIGNAL(finished()), this, SLOT(onReply()));
}

void CxNetwork::del(const QUrl &url, const QJSValue &handler)
{
    qDebug() << "[DELETE]" << url.toString();

    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader,"application/json");

    if (m_firstReq && m_sslErr) {
        m_firstReq = false;

        QSslConfiguration conf = req.sslConfiguration();
        conf.setProtocol(QSsl::TlsV1SslV3);
        conf.setPeerVerifyMode(QSslSocket::VerifyPeer);
        conf.addCaCertificate(m_sslErr->certificate());
        req.setSslConfiguration(conf);
    }

    QNetworkReply *reply = m_networkAccessMgr->deleteResource(req);
    m_responseHanlders.insert(reply, handler);
    connect(reply, SIGNAL(finished()), this, SLOT(onReply()));
}

void CxNetwork::onReply()
{
    QNetworkReply *reply = qobject_cast<QNetworkReply*>(sender());
    if (!reply || !m_responseHanlders.contains(reply)) {
        return;
    }

    QJSValue handler = m_responseHanlders.take(reply);
    if (handler.isCallable()) {
        handler.call(QJSValueList() << QJSValue(QString(reply->readAll())));
    }
}

void CxNetwork::sslErrors(QNetworkReply *reply, QList<QSslError> errs)
{
    Q_UNUSED(errs)
//    for (const QSslError &err: errs) {
//        qDebug() << err.errorString();
//    }
    reply->ignoreSslErrors();
}
