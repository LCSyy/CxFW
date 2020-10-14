#include "localstorage.h"
#include <QDebug>

namespace { static LocalStorage *instance {nullptr}; }

LocalStorage &LocalStorage::self()
{
    if (!instance) {
        instance = new LocalStorage;
        qDebug() << "[CONSTRUCT] LocalStorage";
    }
    return *instance;
}

void LocalStorage::drop()
{
    if (instance) {
        qDebug() << "[DROP] LocalStorages";
        delete instance;
        instance = nullptr;
    }
}

QString LocalStorage::myName() const
{
    return QString("LocalStorage");
}

LocalStorage::LocalStorage(QObject *parent)
    : QObject(parent)
{

}

LocalStorage::~LocalStorage()
{

}
