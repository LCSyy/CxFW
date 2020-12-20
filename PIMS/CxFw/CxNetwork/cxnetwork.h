#ifndef CXNETWORK_H
#define CXNETWORK_H

#include <QObject>
#include <QSslError>
#include <QJSValue>

QT_BEGIN_NAMESPACE
class QNetworkReply;
class QNetworkAccessManager;
QT_END_NAMESPACE

class CxNetwork : public QObject
{
    Q_OBJECT
public:
    explicit CxNetwork(QObject *parent = nullptr);
    ~CxNetwork();

public slots:
    void enableHttps(bool enabled = true);
    void post(const QUrl &url, const QJSValue &body, const QJSValue &handler=QJSValue());
    void get(const QUrl &url, const QJSValue &handler=QJSValue());
    void put(const QUrl &url, const QJSValue &body, const QJSValue &handler=QJSValue());
    void del(const QUrl &url, const QJSValue &handler=QJSValue());
private slots:
    void onReply();
    void sslErrors(QNetworkReply *reply, QList<QSslError> errs);

private:
    QMap<QNetworkReply*, QJSValue> m_responseHanlders;
    bool m_firstReq{true};
    QSslError *m_sslErr{nullptr};
    QNetworkAccessManager *m_networkAccessMgr{nullptr};
};

#endif // CXNETWORK_H
