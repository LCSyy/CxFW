#ifndef LOCALSTORAGE_H
#define LOCALSTORAGE_H

#include "core_global.h"
#include <QObject>

struct LocalStorageData;
class CORE_EXPORT LocalStorage : public QObject
{
    Q_OBJECT
public:
    static LocalStorage &instance();
    static void drop();

protected:
    explicit LocalStorage(QObject *parent = nullptr);
    ~LocalStorage();
    Q_DISABLE_COPY(LocalStorage)

    static LocalStorage *mOnly;

private:
    LocalStorageData *d {nullptr};
};

#endif // LOCALSTORAGE_H
