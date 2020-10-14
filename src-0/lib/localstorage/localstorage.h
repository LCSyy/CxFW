#ifndef LOCALSTORAGE_H
#define LOCALSTORAGE_H

#include "localstorage_global.h"
#include <QDir>
#include <QString>

class LOCALSTORAGE_EXPORT LocalStorage
{
public:
    LocalStorage(const QString &path=QString{});
};

#endif // LOCALSTORAGE_H
