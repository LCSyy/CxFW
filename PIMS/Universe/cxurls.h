#ifndef CXURLS_H
#define CXURLS_H

#include <QObject>
#include <QUrl>

class CxUrls : public QObject
{
    Q_OBJECT
public:
    explicit CxUrls(const QString &scheme,
                    const QString &host,
                    int port,
                    const QString &service,
                    QObject *parent = nullptr);

    Q_INVOKABLE CxUrls *service(const QString &service);
    Q_INVOKABLE QUrl url(const QString &path) const;
    Q_INVOKABLE QUrl url(QString path, const QString &query) const;

private:
    QUrl m_url;
};

#endif // CXURLS_H
