#include "cxurls.h"

CxUrls::CxUrls(const QString &scheme, const QString &host, int port, const QString &service, QObject *parent)
    : QObject(parent)
{
    m_url.setScheme(scheme);
    m_url.setHost(host);
    m_url.setPort(port);
    m_url.setPath(QString("/api/%1").arg(service));
}

QUrl CxUrls::url(const QString &path) const
{
    return url(path,"");
}

QUrl CxUrls::url(QString path, const QString &query) const
{
    if (!path.startsWith("/")) {
        path.prepend("/");
    }

    QUrl url = m_url;
    const QString p = url.path();
    url.setPath(p + path);
    url.setQuery(query);

    return url;
}
