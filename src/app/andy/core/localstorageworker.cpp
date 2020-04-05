#include "localstorageworker.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>

#include <QDebug>

namespace {
constexpr int CURRENT_VERSION_NUM = 2;
constexpr char CURRENT_VERSION_NAME[] = "0.0.2";
}

LocalStorageWorker::LocalStorageWorker(QObject *parent)
    : QObject(parent)
{
    qDebug() << "[Construct] DatabaseWorker";
}

LocalStorageWorker::~LocalStorageWorker()
{
    qDebug() << "[Drop] DatabaseWorker";
}

void LocalStorageWorker::initDatabase(const QString &dbPath)
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

void LocalStorageWorker::dropDatabase()
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

void LocalStorageWorker::createData(const QVariantMap &row)
{
    qDebug() << "[CREATE]";
    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.prepare("INSERT INTO andy_app(content,create_time,modify_time) VALUES(?,datetime('now','localtime'),datetime('now','localtime'));");
    query.addBindValue(row.value("content"));
    query.exec();
}

void LocalStorageWorker::removeData(const QString &id)
{
    qDebug() << "[REMOVE]";

    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.prepare("DELETE FROM andy_app WHERE id = ?;");
    query.addBindValue(id);
    query.exec();
}

QVariantList LocalStorageWorker::loadData(const QString &sql, const QStringList &fields)
{
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

    QVariantList dataRows;
    while (query.next()) {
        QVariantMap row;
        for (const QString &field: fieldIdxHash.keys()) {
            row.insert(field,query.value(field));
        }
        dataRows.append(row);
    }

    return dataRows;
}

void LocalStorageWorker::alterData(const QString &id, const QString &key, const QVariant &val)
{
    qDebug() << "[ALTER]";

    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.prepare(QString("UPDATE andy_app SET %1 = ?, modify_time = datetime('now','localtime') WHERE id = ?;").arg(key));
    query.addBindValue(val);
    query.addBindValue(id);
    query.exec();
}
