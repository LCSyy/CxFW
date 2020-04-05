#include "localstorage.h"
#include <QCoreApplication>
#include <QThread>
#include <QDir>
#include "localstoragethread.h"
#include "localstorageworker.h"

#include <QDebug>

LocalStorage *LocalStorage::only{nullptr};

struct LocalStorageData {
    QThread *dbThread;
    LocalStorageWorker *dbWorker;
    LocalStorageThread *tThread;
    QDir localStorageDir;

    LocalStorageData(LocalStorage *self)
        : dbThread(new QThread(self))
        , dbWorker(new LocalStorageWorker)
        , tThread(new LocalStorageThread(self))
        , localStorageDir(qApp->applicationDirPath())
    {
        localStorageDir.cdUp();
        if (!localStorageDir.cd("common")) {
            localStorageDir.mkdir("common");
            localStorageDir.cd("common");
        }
        if (!localStorageDir.cd("localdb")) {
            localStorageDir.mkdir("localdb");
            localStorageDir.cd("localdb");
        }

        /*
        QObject::connect(dbWorker, SIGNAL(dataLoaded(const QVariantList&)),
                         self, SIGNAL(dataLoaded(const QVariantList&)));

        QObject::connect(dbThread, SIGNAL(finished()),
                         dbWorker, SLOT(deleteLater()));

        dbWorker->moveToThread(dbThread);
        dbThread->start();
        */
    }

    ~LocalStorageData() {
        tThread->dropDatabase();
        tThread->wait();
        // dbThread->exit();
        // dbThread->wait();
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
//    QMetaObject::invokeMethod(d->dbWorker,
//                              "initDatabase",
//                              Qt::QueuedConnection,
//                              Q_ARG(const QString&,localStorageFilePath()));
    d->tThread->initDatabase(localStorageFilePath());
}

void LocalStorage::dropDatabase()
{
//    QMetaObject::invokeMethod(d->dbWorker,
//                              "dropDatabase",
//                              Qt::QueuedConnection);
    d->tThread->dropDatabase();
}

void LocalStorage::loadData(const QString &sql, const QStringList &fields)
{
//    const QStringList fields{"id","content","createTime","modifyTime"};
//    QMetaObject::invokeMethod(d->dbWorker,
//                              "loadData",
//                              Qt::QueuedConnection,
//                              Q_ARG(const QString&,"SELECT * FROM andy_app"),
//                              Q_ARG(const QStringList&,fields));
}

void LocalStorage::createData(const QVariantMap &row)
{
//    QMetaObject::invokeMethod(d->dbWorker,
//                              "createData",
//                              Qt::QueuedConnection,
//                              Q_ARG(const QVariantMap&,row));
}

void LocalStorage::removeData(const QString &id)
{
//    QMetaObject::invokeMethod(d->dbWorker,
//                              "removeData",
//                              Qt::QueuedConnection,
//                              Q_ARG(const QString&,id));
}

void LocalStorage::alterData(const QString &id, const QString &key, const QVariant &val)
{
//    QMetaObject::invokeMethod(d->dbWorker,
//                              "alterData",
//                              Qt::QueuedConnection,
//                              Q_ARG(const QString&,id),
//                              Q_ARG(const QString&,key),
//                              Q_ARG(const QVariant&,val));
}

QVariantList LocalStorage::getResultImmediately(const QString &sql, const QStringList &fields)
{
    QVariantList dataRows;
//    QMetaObject::invokeMethod(d->dbWorker,"loadDataV2",
//                              Qt::DirectConnection,
//                              Q_RETURN_ARG(QVariantList,dataRows),
//                              Q_ARG(const QString&,sql),
//                              Q_ARG(const QStringList&,fields));
    d->tThread->loadData(sql,fields);
    d->tThread->wait();
    return d->tThread->dataRows();
}
