#ifndef STORAGEMANAGER_H
#define STORAGEMANAGER_H

#include <QObject>

class StorageManager : public QObject
{
    Q_OBJECT
public:

    static StorageManager *instance();
    static StorageManager &self();
    static void drop();

signals:

protected:
    explicit StorageManager(QObject *parent = nullptr);
    ~StorageManager();
    Q_DISABLE_COPY(StorageManager)

    static StorageManager *only;
};

#endif // STORAGEMANAGER_H
