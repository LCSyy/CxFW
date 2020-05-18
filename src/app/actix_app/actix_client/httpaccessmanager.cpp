#include "httpaccessmanager.h"
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

#include <QDebug>

#define dbg(x) qDebug().noquote() << QString{"[line:%1, func:%2]\t"}.arg(__LINE__).arg(__FUNCTION__) << x;

HttpAccessManager::HttpAccessManager(QObject *parent)
    : QObject(parent)
    , http(new QNetworkAccessManager(this))
{
    dbg("construct HttpAccessManager")

    connect(http,SIGNAL(finished(QNetworkReply*)),this,SLOT(onReplyFinished(QNetworkReply*)));
}

void HttpAccessManager::request(const QString &msg)
{
    dbg("request")
    const QUrl url{"http://127.0.0.1:9001/app/register"};
    QNetworkRequest req{url};

    req.setHeader(QNetworkRequest::ContentTypeHeader,"text/plain,charset=UTF-8");
    http->post(req,QByteArray{}.append(msg));
}

void HttpAccessManager::onReplyFinished(QNetworkReply *reply)
{
    dbg("reply")
    emit dataLoaded(QVariantMap{
                        {"method", "app_register"},
                        {"msg", QString{reply->readAll()}}
                    },QPrivateSignal{});
}
