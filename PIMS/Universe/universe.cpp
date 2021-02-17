#include "universe.h"

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
