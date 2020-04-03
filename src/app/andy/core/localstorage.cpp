#include "localstorage.h"
#include <QCoreApplication>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QDir>

#include <QDebug>

LocalStorage *LocalStorage::only{nullptr};

constexpr int CURRENT_VERSION_NUM = 2;
constexpr char CURRENT_VERSION_NAME[] = "0.0.2";

struct LocalStorageData {
    QThread *dbThread;
    DatabaseWorker *dbWorker;
    QDir localStorageDir;

    LocalStorageData(LocalStorage *self)
        : dbThread(new QThread(self))
        , dbWorker(new DatabaseWorker)
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

        QObject::connect(dbWorker, SIGNAL(dataLoaded(const QVariantList&)),
                         self, SIGNAL(dataLoaded(const QVariantList&)));

        QObject::connect(dbThread, SIGNAL(finished()),
                         dbWorker, SLOT(deleteLater()));

        dbWorker->moveToThread(dbThread);
        dbThread->start();
    }

    ~LocalStorageData() {
        dbThread->exit();
        dbThread->wait();
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
    QMetaObject::invokeMethod(d->dbWorker,
                              "initDatabase",
                              Qt::QueuedConnection,
                              Q_ARG(const QString&,localStorageFilePath()));
}

void LocalStorage::dropDatabase()
{
    QMetaObject::invokeMethod(d->dbWorker,
                              "dropDatabase",
                              Qt::QueuedConnection);
}

void LocalStorage::loadData()
{
    const QStringList fields{"id","content","createTime","modifyTime"};
    QMetaObject::invokeMethod(d->dbWorker,
                              "loadData",
                              Qt::QueuedConnection,
                              Q_ARG(const QString&,"SELECT * FROM andy_app"),
                              Q_ARG(const QStringList&,fields));
}

void LocalStorage::createData(const QVariantMap &row)
{
    QMetaObject::invokeMethod(d->dbWorker,
                              "createData",
                              Qt::QueuedConnection,
                              Q_ARG(const QVariantMap&,row));
}

void LocalStorage::removeData(const QString &id)
{
    QMetaObject::invokeMethod(d->dbWorker,
                              "removeData",
                              Qt::QueuedConnection,
                              Q_ARG(const QString&,id));
}

void LocalStorage::alterData(const QString &id, const QString &key, const QVariant &val)
{
    QMetaObject::invokeMethod(d->dbWorker,
                              "alterData",
                              Qt::QueuedConnection,
                              Q_ARG(const QString&,id),
                              Q_ARG(const QString&,key),
                              Q_ARG(const QVariant&,val));
}

DatabaseWorker::DatabaseWorker(QObject *parent)
    : QObject(parent)
{
    qDebug() << "[Construct] DatabaseWorker";
}

DatabaseWorker::~DatabaseWorker()
{
    qDebug() << "[Drop] DatabaseWorker";
}

void DatabaseWorker::initDatabase(const QString &dbPath)
{
    qDebug() << "[Init] database";

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbPath);
    if (!db.open()) {
        qDebug() << "[ERROR] local database connection error";
    } else {
        // init logic
        try {
            db.transaction();
            QSqlQuery query(db);
            query.exec("CREATE TABLE IF NOT EXISTS sys_info(id INTEGER PRIMARY KEY AUTOINCREMENT, ver_num INTEGER, ver_text TEXT, update_log TEXT, create_time TEXT);");
            if (query.lastError().isValid()) {
                throw query.lastError();
            }
            query.exec("CREATE TABLE IF NOT EXISTS sys_users(id INTEGER PRIMARY KEY AUTOINCREMENT, account TEXT);");
            if (query.lastError().isValid()) {
                throw query.lastError();
            }
            query.exec("CREATE TABLE IF NOT EXISTS user_info(id INTEGER PRIMARY KEY AUTOINCREMENT, uuid TEXT, account TEXT, password BLOB, info BLOB, create_time TEXT);");
            if (query.lastError().isValid()) {
                throw query.lastError();
            }
            query.exec("CREATE TABLE IF NOT EXISTS user_data(id INTEGER PRIMARY KEY AUTOINCREMENT, user_uuid TEXT, content BLOB, create_time TEXT, modify_time TEXT);");
            if (query.lastError().isValid()) {
                throw query.lastError();
            }
            query.exec("CREATE TABLE IF NOT EXISTS andy_app(id INTEGER PRIMARY KEY AUTOINCREMENT, content BLOB, seq INTEGER, create_time TEXT, modify_time TEXT);");
            if (query.lastError().isValid()) {
                throw query.lastError();
            }

            query.exec("SELECT max(ver_num) AS ver_num FROM sys_info;");
            QSqlRecord record = query.record();
            const int verNumIdx = record.indexOf("ver_num");
            int maxVerNum = -1;
            while (query.next()) {
                maxVerNum = query.value(verNumIdx).toInt();
            }

            const QString writeVersionInfoSql = QString("INSERT INTO sys_info(ver_num,ver_text,create_time) "
                                                        "VALUES(%1,'%2',datetime('now','localtime'));")
                                                        .arg(CURRENT_VERSION_NUM).arg(CURRENT_VERSION_NAME);
            if (maxVerNum < CURRENT_VERSION_NUM) {
                query.exec(writeVersionInfoSql);
                if (query.lastError().isValid()) {
                    throw query.lastError();
                }

                // upgrade logic
                query.exec("ALTER TABLE andy_app ADD COLUMN seq INTEGER");
                if (query.lastError().isValid()) {
                    throw query.lastError();
                }
            }

            db.commit();
        } catch (const QSqlError &err) {
            qDebug() << "[ERROR] Init Database error: " << err.text();
            db.rollback();
        }
    }
}

void DatabaseWorker::dropDatabase()
{
    qDebug() << "[Drop] database";

    QString connectionName;
    {
        QSqlDatabase db = QSqlDatabase::database();
        connectionName = db.connectionName();
        db.close();
    }
    QSqlDatabase::removeDatabase(connectionName);
}

void DatabaseWorker::loadData(const QString &sql, const QStringList &fields)
{
    qDebug() << "[Load] datalist";
    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.exec(sql);
    QSqlRecord r = query.record();

    QHash<QString,int> indexHash;
    for (const QString &field: fields) {
        const int idx = r.indexOf(field);
        if (idx != -1) {
            indexHash.insert(field,idx);
        }
    }

    QVariantList dataLst;
    while (query.next()) {
        QVariantMap dataMap;
        for (const QString &field: indexHash.keys()) {
            const int idx = indexHash[field];
            dataMap.insert(field,query.value(idx));
        }
        dataLst.append(dataMap);
    }

    qDebug() << "[Load] Load Finished";
    emit dataLoaded(dataLst, QPrivateSignal{});
}

void DatabaseWorker::createData(const QVariantMap &row)
{
    qDebug() << "[CREATE]";
    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.prepare("INSERT INTO andy_app(content,create_time,modify_time) VALUES(?,datetime('now','localtime'),datetime('now','localtime'));");
    query.addBindValue(row.value("content"));
    query.exec();
}

void DatabaseWorker::removeData(const QString &id)
{
    qDebug() << "[REMOVE]";

    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.prepare("DELETE FROM andy_app WHERE id = ?;");
    query.addBindValue(id);
    query.exec();
}

void DatabaseWorker::alterData(const QString &id, const QString &key, const QVariant &val)
{
    qDebug() << "[ALTER]";

    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.prepare(QString("UPDATE andy_app SET %1 = ?, modify_time = datetime('now','localtime') WHERE id = ?;").arg(key));
    query.addBindValue(val);
    query.addBindValue(id);
    query.exec();
}
