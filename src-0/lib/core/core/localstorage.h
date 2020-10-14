#ifndef LOCALSTORAGE_H
#define LOCALSTORAGE_H

#include "core_global.h"
#include <QObject>

class CORE_EXPORT LocalStorage : public QObject
{
    Q_OBJECT
public:
    static LocalStorage &self();
    static void drop();

    QString myName() const;

protected:
    Q_DISABLE_COPY(LocalStorage)
    explicit LocalStorage(QObject *parent = nullptr);
    ~LocalStorage() override;
};

#endif // LOCALSTORAGE_H
