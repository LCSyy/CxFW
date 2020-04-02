#ifndef STORAGEMANAGER_H
#define STORAGEMANAGER_H

#include "core_global.h"
#include <QObject>

class Storage;
class CORE_EXPORT StorageManager: public QObject
{
    Q_OBJECT
public:

    static StorageManager *instance();
    static StorageManager &self();
    static void drop();

    Storage *storage() const;

protected:
    explicit StorageManager(QObject *parent = nullptr);
    ~StorageManager();
    Q_DISABLE_COPY(StorageManager)

    static StorageManager *only;
};

#endif // STORAGEMANAGER_H
