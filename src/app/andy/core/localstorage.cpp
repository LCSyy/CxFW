#include "localstorage.h"
#include <QCoreApplication>
#include <QThread>
#include <QtConcurrent>
#include <QDir>
#include "localstorageworker.h"

#include <QDebug>

LocalStorage *LocalStorage::only{nullptr};

struct LocalStorageData {
    LocalStorageWorker *dbWorker;
    QDir localStorageDir;

    LocalStorageData(LocalStorage *self)
        : dbWorker(new LocalStorageWorker(self))
        , localStorageDir(qApp->applicationDirPath())
    {
        Q_UNUSED(self)

        localStorageDir.cdUp();
        if (!localStorageDir.cd("common")) {
            localStorageDir.mkdir("common");
            localStorageDir.cd("common");
        }
        if (!localStorageDir.cd("localdb")) {
            localStorageDir.mkdir("localdb");
            localStorageDir.cd("localdb");
        }
    }

    ~LocalStorageData() {
    }

};

LocalStorage::LocalStorage(QObject *parent)
    : QObject(parent)
    , d(new LocalStorageData(this))
{
    qDebug() << "[Construct] LocalStorage";
}

LocalStorage::~LocalStorage()
{
    if (d) {
        delete d;
        d = nullptr;
    }

    qDebug() << "[Drop] LocalStorage";
}

LocalStorage *LocalStorage::instance()
{
    if (!only) {
        only = new LocalStorage;
    }
    return only;
}

LocalStorage &LocalStorage::self()
{
    return *instance();
}

void LocalStorage::drop()
{
    if (only) {
        delete only;
        only = nullptr;
    }
}

QString LocalStorage::localStorageFilePath() const
{
    if (d && !d->localStorageDir.isEmpty()) {
        return d->localStorageDir.absoluteFilePath("andy-app.db");
    }
    return QString("");
}

void LocalStorage::initDatabase()
{
    d->dbWorker->initDatabase(localStorageFilePath());
}

void LocalStorage::dropDatabase()
{
    d->dbWorker->dropDatabase();
}

QVariantList LocalStorage::loadData(const QString &sql, const QStringList &fields)
{
    return d->dbWorker->loadData(sql,fields);
}

void LocalStorage::createData(const QVariantMap &row)
{
    d->dbWorker->createData(row);
}

void LocalStorage::removeData(const QString &id)
{
    d->dbWorker->removeData(id);
}

void LocalStorage::alterData(const QString &id, const QString &key, const QVariant &val)
{
    d->dbWorker->alterData(id,key,val);
}
