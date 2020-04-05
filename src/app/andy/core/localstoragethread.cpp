#include "localstoragethread.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QDebug>

constexpr int THREAD_CURRENT_VERSION_NUM = 2;
constexpr char THREAD_CURRENT_VERSION_NAME[] = "0.0.2";

namespace {
constexpr char INIT_DB[] = "INIT_DB";
constexpr char REMOVE_DB[] = "REMOVE_DB";
constexpr char LOAD_DATA[] = "LOAD_DATA";
}

LocalStorageThread::LocalStorageThread(QObject *parent)
    : QThread(parent)
{

}

LocalStorageThread::~LocalStorageThread()
{

}

void LocalStorageThread::initDatabase(const QString &dbPath)
{
    invokeName = QString(INIT_DB);
    invokeParams.insert("param",dbPath);
    start();
}

void LocalStorageThread::dropDatabase()
{
    invokeName = QString(REMOVE_DB);
    start();
}

void LocalStorageThread::loadData(const QString &sql, const QStringList &fields)
{
    invokeName = QString(LOAD_DATA);
    invokeParams.insert("sql",sql);
    invokeParams.insert("fields",fields);
    start();
}

const QVariantList &LocalStorageThread::dataRows() const
{
    return datas;
}

void LocalStorageThread::run()
{
    if (invokeName == QString(INIT_DB)) {
        initDB(invokeParams.value("param").toString());
    } else if (invokeName == QString(REMOVE_DB)) {
        removeDB();
    } else if (invokeName == QString(LOAD_DATA)) {
        pLoadData(invokeParams.value("sql").toString(),
                 invokeParams.value("fields").toStringList());
    }
}

void LocalStorageThread::initDB(const QString &dbPath)
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
                                                        .arg(THREAD_CURRENT_VERSION_NUM).arg(THREAD_CURRENT_VERSION_NAME);
            if (maxVerNum < THREAD_CURRENT_VERSION_NUM) {
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

void LocalStorageThread::removeDB()
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

void LocalStorageThread::pLoadData(const QString &sql, const QStringList &fields)
{
    datas.clear();

    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.exec(sql);

    QHash<QString,int> fieldIdxHash;
    QSqlRecord r = query.record();
    if (!fields.isEmpty()) {
        for (const QString &field: fields) {
            const int idx = r.indexOf(field);
            if (idx != -1) {
                fieldIdxHash.insert(field,idx);
            }
        }
    } else {
        for (int i = 0; i < r.count(); ++i) {
            const QString field = r.fieldName(i);
            fieldIdxHash.insert(field,i);
        }
    }

    while (query.next()) {
        QVariantMap row;
        for (const QString &field: fieldIdxHash.keys()) {
            row.insert(field,query.value(field));
        }
        datas.append(row);
    }
}
