#include "localstorage.h"
#include <QCoreApplication>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QDir>

#include <QDebug>

constexpr int CURRENT_VERSION_NUM = 1;
constexpr char CURRENT_VERSION_NAME[] = "0.0.1";

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

        // drop storage
        QObject::connect(self,SIGNAL(dropStorage()),dbWorker,SLOT(dropDatabase()));

        // load data
        QObject::connect(self, SIGNAL(loadData()), dbWorker, SLOT(loadDataList()));
        QObject::connect(dbWorker, SIGNAL(dataLoaded(const QVariantList&)), self, SIGNAL(dataHasLoad(QVariantList)));

        // create data
        QObject::connect(self, SIGNAL(createData(const QVariantMap&)), dbWorker, SLOT(createData(const QVariantMap&)));
        QObject::connect(dbWorker, SIGNAL(dataCreated()), self, SIGNAL(dataCreated()));

        // remove data
        QObject::connect(self, SIGNAL(removeData(const QString&)), dbWorker, SLOT(removeData(const QString&)));
        QObject::connect(dbWorker, SIGNAL(dataRemoved()), self, SIGNAL(dataRemoved()));

        // alter data
        QObject::connect(self, SIGNAL(alterData(const QString &, const QString &, const QVariant&)),
                         dbWorker, SLOT(alterData(const QString &, const QString &, const QVariant&)));
        QObject::connect(dbWorker, SIGNAL(dataAltered()), self, SIGNAL(dataAltered()));

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
    emit dropStorage(QPrivateSignal{});

    if (d) {
        delete d;
        d = nullptr;
    }

    qDebug() << "[Drop] LocalStorage";
}

QString LocalStorage::localStorageFilePath() const
{
    if (d && !d->localStorageDir.isEmpty()) {
        return d->localStorageDir.absoluteFilePath("andy-app.db");
    }
    return QString("");
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

void DatabaseWorker::loadDataList()
{
    qDebug() << "[Load] datalist";
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
    emit dataLoaded(dataLst);
}

void DatabaseWorker::createData(const QVariantMap &row)
{
    qDebug() << "[CREATE]";
    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.prepare("INSERT INTO andy_app(content,create_time,modify_time) VALUES(?,datetime('now','localtime'),datetime('now','localtime'));");
    query.addBindValue(row.value("content"));
    query.exec();

    emit dataCreated();
}

void DatabaseWorker::removeData(const QString &id)
{
    qDebug() << "[REMOVE]";

    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.prepare("DELETE FROM andy_app WHERE id = ?;");
    query.addBindValue(id);
    query.exec();

    emit dataRemoved();
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

    emit dataAltered();
}
