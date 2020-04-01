#ifndef LOCALSTORAGE_H
#define LOCALSTORAGE_H

#include "core_global.h"
#include <QObject>
#include <QVariant>
#include <QVector>

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

signals:
    void initStorage(const QString &path);
    void storageInitialed();

    void dropStorage(QPrivateSignal);

    void loadData();
    void dataHasLoad(QVariantList);

    void createData(const QVariantMap&);
    void dataCreated();

    void removeData(const QString &);
    void dataRemoved();

    void alterData(const QString &, const QString &, const QVariant&);
    void dataAltered();

protected:
    explicit LocalStorage(QObject *parent = nullptr);
    Q_DISABLE_COPY(LocalStorage)

    static LocalStorage *only;

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
    void dataCreated();
    void dataRemoved();
    void dataAltered();

public slots:
    void initDatabase(const QString &dbPath);
    void dropDatabase();
    void loadDataList();
    void createData(const QVariantMap &row);
    void removeData(const QString &id);
    void alterData(const QString &id, const QString &key, const QVariant &val);
};

#endif // LOCALSTORAGE_H
