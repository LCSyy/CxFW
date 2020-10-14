#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>

QT_BEGIN_NAMESPACE
class QNetworkReply;
class QNetworkAccessManager;
QT_END_NAMESPACE

class NetworkManager : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent = nullptr);

public slots:
    void doSth();
private:
    QNetworkAccessManager *accessMgt {nullptr};
    QNetworkReply *reply {nullptr};
};

#endif // NETWORKMANAGER_H
