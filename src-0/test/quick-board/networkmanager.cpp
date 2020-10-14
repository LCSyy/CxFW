#include "networkmanager.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonObject>
#include <QJsonValue>
#include <QDebug>

NetworkManager::NetworkManager(QObject *parent)
    : QObject(parent)
    , accessMgt(new QNetworkAccessManager(this))
{
}

void NetworkManager::doSth()
{
    QNetworkRequest req(QUrl("http://127.0.0.1/app/list"));
    accessMgt->get(req);
    connect(accessMgt,&QNetworkAccessManager::finished,[](QNetworkReply *reply){
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        const QVariantList rowLst = doc.toVariant().toList();
        for(const QVariant &row: rowLst) {
            const QVariantMap rowMap = row.toMap();
        }
    });
}
