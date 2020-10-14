#ifndef LOCALSTORAGE_H
#define LOCALSTORAGE_H

#include "itcore_global.h"

#include <QVariantList>

struct StoryRow {
};

class ITCORE_EXPORT LocalStorage
{
public:
    static LocalStorage &self();
    static void drop();

    QVariantList loadData(const QString &sql);

private:
    LocalStorage();
    ~LocalStorage();

    LocalStorage(const LocalStorage&);
    LocalStorage &operator=(const LocalStorage&);
};

#endif // LOCALSTORAGE_H
