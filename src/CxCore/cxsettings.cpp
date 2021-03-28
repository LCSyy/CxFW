#include "cxsettings.h"

CxSettings::CxSettings(QObject *parent)
    : QSettings(parent)
{

}

QVariant CxSettings::get(const QString &key) const
{
    return QSettings::value(key);
}

void CxSettings::beginReadArray(const QString &prefix)
{
    QSettings::beginReadArray(prefix);
}

void CxSettings::beginWriteArray(const QString &prefix)
{
    QSettings::beginWriteArray(prefix);
}

void CxSettings::setArrayIndex(int i)
{
    QSettings::setArrayIndex(i);
}

void CxSettings::endArray()
{
    QSettings::endArray();
}

void CxSettings::set(const QString &key, const QVariant &val)
{
    QSettings::setValue(key, val);
}
