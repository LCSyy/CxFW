#ifndef CXNETWORK_H
#define CXNETWORK_H

#include <QObject>
#include <QSslError>
#include <QJSValue>

QT_BEGIN_NAMESPACE
class QNetworkReply;
class QNetworkAccessManager;
class QNetworkRequest;
QT_END_NAMESPACE

class CxNetwork : public QObject
{
    Q_OBJECT

public:

    enum Verbs {
        POST,
        DELETE,
        DELETE2,
        GET,
        PUT,
        PATCH,
    };

public:
    explicit CxNetwork(QObject *parent = nullptr);
    ~CxNetwork();

public slots:
    void enableHttps(bool enabled = true);
    void post(const QUrl &url, const QJSValue &header, const QJSValue &body, const QJSValue &handler=QJSValue());
    void get(const QUrl &url, const QJSValue &header, const QJSValue &handler=QJSValue());
    void put(const QUrl &url, const QJSValue &header, const QJSValue &body, const QJSValue &handler=QJSValue());
    void patch(const QUrl &url, const QJSValue &header, const QJSValue &body, const QJSValue &handler=QJSValue());
    void del(const QUrl &url, const QJSValue &header, const QJSValue &handler=QJSValue());
    void del2(const QUrl &url, const QJSValue &header, const QJSValue &body=QJSValue(), const QJSValue &handler=QJSValue());
    void upload(const QUrl &url, const QJSValue &header, const QStringList &resList, const QJSValue &handler=QJSValue());
    void download(const QUrl &url, const QJSValue &header, const QString &query = QString("name"), const QJSValue &handler=QJSValue());

private slots:
    void onReply();
    void sslErrors(QNetworkReply *reply, QList<QSslError> errs);

private:
    QNetworkRequest newRequest(const QUrl &url, const QJSValue &header);

    void request(Verbs verb,
                 const QUrl &url,
                 const QJSValue &header=QJSValue(),
                 const QJSValue &body=QJSValue(),
                 const QJSValue &handler=QJSValue());

private:
    QMap<QNetworkReply*, QJSValue> m_responseHanlders;
    bool m_firstReq{true};
    QSslError *m_sslErr{nullptr};
    QNetworkAccessManager *m_networkAccessMgr{nullptr};
};

#endif // CXNETWORK_H
