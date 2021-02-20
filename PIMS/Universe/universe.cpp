#include "universe.h"
#include <QUrl>
#include <QFileInfo>

Universe::Universe(QObject *parent)
    : QObject(parent)
{

}

void Universe::setData(const QString &key, const QVariant &data)
{
    m_datas.insert(key, data);
}

QVariant Universe::getData(const QString &key) const
{
    return m_datas.value(key);
}

QString Universe::fileName(const QUrl &url) const
{
    QFileInfo info(url.path());
    return info.fileName();
}
