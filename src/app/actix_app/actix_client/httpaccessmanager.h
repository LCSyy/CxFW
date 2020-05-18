#ifndef HTTPACCESSMANAGER_H
#define HTTPACCESSMANAGER_H

#include <QObject>
#include <QUrl>
#include <QVariantMap>

QT_BEGIN_NAMESPACE
class QNetworkAccessManager;
class QNetworkReply;
QT_END_NAMESPACE

class HttpAccessManager : public QObject
{
    Q_OBJECT
public:
    explicit HttpAccessManager(QObject *parent = nullptr);

signals:
    void dataLoaded(QVariantMap data, QPrivateSignal);

public slots:
    void request(const QString &msg);

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *http {nullptr};

    struct HttpConfig {
        QUrl url;
    } httpConfig;
};

#endif // HTTPACCESSMANAGER_H
