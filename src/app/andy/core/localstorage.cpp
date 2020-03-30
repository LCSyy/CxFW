#include "localstorage.h"
#include <QCoreApplication>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDir>

#include <QDebug>

LocalStorage *LocalStorage::mOnly{nullptr};

constexpr int CURRENT_VERSION_NUM = 1;
constexpr char CURRENT_VERSION_NAME[] = "0.0.1";

// const char ANDY_APP_TABLE[] = "andy_app";
// const char SYS_INFO_TABLE[] = "sys_info";
// const char USER_INFO_TABLE[] = "user_info";

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

        // init storage
        QObject::connect(self, SIGNAL(initStorage(const QString&)), dbWorker, SLOT(initDatabase(const QString&)));
        QObject::connect(dbWorker, SIGNAL(storageInitialed()), self, SIGNAL(storageInitialed()));

        // load data
        QObject::connect(self, SIGNAL(loadData()), dbWorker, SLOT(loadDataList()));
        QObject::connect(dbWorker, SIGNAL(dataLoaded(const QVariantList&)), self, SIGNAL(dataHasLoad(QVariantList)));

        QObject::connect(dbThread, SIGNAL(finished()),
                         dbWorker, SLOT(deleteLater()));

        dbWorker->moveToThread(dbThread);
        dbThread->start();
    }

};

LocalStorage::LocalStorage(QObject *parent)
    : QObject(parent)
    , d(new LocalStorageData(this))
{
    qDebug() << "Construct LocalStorage";
}

LocalStorage::~LocalStorage()
{
    if (d) {
        d->dbThread->exit();
        delete d;
        d = nullptr;
    }

    qDebug() << "Drop LocalStorage";
}

LocalStorage *LocalStorage::self()
{
    if (!mOnly) {
        mOnly = new LocalStorage();
    }
    return mOnly;
}

LocalStorage &LocalStorage::instance()
{
    if (!mOnly) {
        mOnly = new LocalStorage();
    }
    return *mOnly;
}

void LocalStorage::drop()
{
    if (mOnly) {
        delete mOnly;
        mOnly = nullptr;
    }
}

QString LocalStorage::localStorageFilePath() const
{
    return d->localStorageDir.absoluteFilePath("andy-app.db");
}

DatabaseWorker::DatabaseWorker(QObject *parent)
    : QObject(parent)
{

}

DatabaseWorker::~DatabaseWorker()
{
    qDebug() << "Database worker destroyed!";
}

void DatabaseWorker::initDatabase(const QString &dbPath)
{
    qDebug() << "localdb dir:" << dbPath;

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dbPath);
    if (!db.open()) {
        qDebug() << "[ERROR] local database connection error";
    } else {
        QSqlQuery query(db);
        query.exec("CREATE TABLE IF NOT EXISTS sys_info(id INTEGER PRIMARY KEY AUTOINCREMENT, ver_num INTEGER, ver_text TEXT, update_log TEXT, create_time TEXT);");
        query.exec("CREATE TABLE IF NOT EXISTS andy_app(id INTEGER PRIMARY KEY AUTOINCREMENT, content BLOB, create_time TEXT, modify_time TEXT);");

        query.exec("SELECT max(ver_num) AS ver_num FROM sys_info;");
        QSqlRecord record = query.record();
        const int verNumIdx = record.indexOf("ver_num");
        int maxVerNum = -1;
        while (query.next()) {
            maxVerNum = query.value(verNumIdx).toInt();
        }

        qDebug() << "Current version:" << maxVerNum;

        const QString writeVersionInfoSql = QString("INSERT INTO sys_info(ver_num,ver_text,create_time) "
                                                    "VALUES(%1,'%2',datetime('now','localtime'));").arg(CURRENT_VERSION_NUM).arg(CURRENT_VERSION_NAME);

        if (maxVerNum == -1) {
            query.exec(writeVersionInfoSql);
        }

        // if (maxVerNum != -1 && maxVerNum < CURRENT_VERSION_NUM) { // 没有升级到当前版本，需要升级
        //     query.exec(QString("BEGIN;"
        //                "ALTER TABLE andy_app ADD COLUMN content_blob BLOB;"
        //                "ALTER TABLE andy_app ADD COLUMN modify_time TEXT;%1"
        //                "COMMIT;").arg(writeVersionInfoSql));
        // }
    }
}

void DatabaseWorker::loadDataList()
{
    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.exec("SELECT * FROM andy_app");
    QSqlRecord r = query.record();
    const int idIdx = r.indexOf("id");
    const int contentIdx = r.indexOf("content");
    const int createTimeIdx = r.indexOf("create_time");
    const int modifyTimeIdx = r.indexOf("modify_time");
    QVariantList dataLst;
    while (query.next()) {
        QVariantMap dataMap;
        dataMap.insert("uid",query.value(idIdx));

        dataMap.insert("content",query.value(contentIdx));
        dataMap.insert("createTime", query.value(createTimeIdx));
        dataMap.insert("modifyTime",query.value(modifyTimeIdx));
        dataLst.append(dataMap);
    }
    qDebug() << "[SELECT] size:" << dataLst.size();
    emit dataLoaded(dataLst);
}
