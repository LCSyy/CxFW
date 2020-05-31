#ifndef LOCALSTORAGE_H
#define LOCALSTORAGE_H

#include "itcore_global.h"

struct StoryRow {
};

class ITCORE_EXPORT LocalStorage
{
public:
    static LocalStorage &self();
    static void drop();

    void loadData(const QString &sql);

private:
    LocalStorage();
    ~LocalStorage();

    LocalStorage(const LocalStorage&);
    LocalStorage &operator=(const LocalStorage&);
};

#endif // LOCALSTORAGE_H
