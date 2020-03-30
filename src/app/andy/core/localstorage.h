#ifndef LOCALSTORAGE_H
#define LOCALSTORAGE_H

#include "core_global.h"
#include <QObject>
#include <QVariant>

struct LocalStorageData;
class CORE_EXPORT LocalStorage : public QObject
{
    Q_OBJECT
public:
    explicit LocalStorage(QObject *parent = nullptr);
    ~LocalStorage();

    static LocalStorage *self();
    static LocalStorage &instance();
    static void drop();

    QString localStorageFilePath() const;

signals:
    void initStorage(const QString &path);
    void storageInitialed();

    void loadData();
    void dataHasLoad(QVariantList);

protected:
    // explicit LocalStorage(QObject *parent = nullptr);
    // ~LocalStorage();
    // Q_DISABLE_COPY(LocalStorage)

    static LocalStorage *mOnly;

private:
    LocalStorageData *d {nullptr};
};


class DatabaseWorker: public QObject
{
    Q_OBJECT
public:
    explicit DatabaseWorker(QObject *parent = nullptr);
    ~DatabaseWorker();

signals:
    void storageInitialed();
    void dataLoaded(const QVariantList&);

public slots:
    void initDatabase(const QString &dbPath);
    void loadDataList();
};

#endif // LOCALSTORAGE_H
