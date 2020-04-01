#include "storagemanager.h"

StorageManager *StorageManager::only{nullptr};

StorageManager::StorageManager(QObject *parent) : QObject(parent)
{

}

StorageManager::~StorageManager()
{

}

StorageManager *StorageManager::instance()
{
    if (!only) {
        only = new StorageManager;
    }
    return only;
}

StorageManager &StorageManager::self()
{
    return *instance();
}

void StorageManager::drop()
{
    if (only) {
        delete only;
        only = nullptr;
    }
}


Storage *StorageManager::storage() const
{
}
