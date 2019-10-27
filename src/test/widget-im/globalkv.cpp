#include "globalkv.h"
#include <QDebug>

namespace {
    static GlobalKV *singleton = nullptr;
}

GlobalKV *GlobalKV::instance()
{
    if(!::singleton) {
        ::singleton = new GlobalKV;
    }
    return ::singleton;
}

void GlobalKV::destroy()
{
    if(::singleton) {
        delete ::singleton;
        ::singleton = nullptr;
    }
}

GlobalKV::GlobalKV(QObject *parent) : QObject(parent)
{
    qDebug() << "construct GlobalKY";
}

void GlobalKV::set(const QString &key, const QVariant &val)
{
    mDataMap.insert(key,val);
}

QVariant GlobalKV::value(const QString &key) const
{
    return mDataMap.value(key);
}
