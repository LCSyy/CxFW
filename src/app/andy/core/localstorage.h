#ifndef LOCALSTORAGE_H
#define LOCALSTORAGE_H

#include "core_global.h"
#include <QObject>
#include <QVariant>
#include <QVector>

class DatabaseWorker;

struct LocalStorageData;
class CORE_EXPORT LocalStorage : public QObject
{
    Q_OBJECT
public:
    ~LocalStorage();

    static LocalStorage *instance();
    static LocalStorage &self();
    static void drop();

    QString localStorageFilePath() const;

    DatabaseWorker *storage() const;

protected:
    explicit LocalStorage(QObject *parent = nullptr);
    Q_DISABLE_COPY(LocalStorage)

    static LocalStorage *only;

private:
    LocalStorageData *d {nullptr};
};

class CORE_EXPORT DatabaseWorker: public QObject
{
    Q_OBJECT
public:
    explicit DatabaseWorker(QObject *parent = nullptr);
    ~DatabaseWorker();

signals:
    void storageInitialed(QPrivateSignal);
    void dataLoaded(const QVariantList&,QPrivateSignal);
    void dataCreated(QPrivateSignal);
    void dataRemoved(QPrivateSignal);
    void dataAltered(QPrivateSignal);

public slots:
    void initDatabase(const QString &dbPath);
    void dropDatabase();
    void loadDataList();
    void createData(const QVariantMap &row);
    void removeData(const QString &id);
    void alterData(const QString &id, const QString &key, const QVariant &val);
};

#endif // LOCALSTORAGE_H
