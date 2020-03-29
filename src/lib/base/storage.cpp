#include "storage.h"
#include <QVariantMap>
// #include <botan/rng.h>
#include <third_party/sqlite3/sqlite3.h>

#include <iostream>
#include <QDebug>

namespace cx {

static sqlite3 *db = nullptr;

uint Storage::requestIdPtr = 0;
QVector<uint> Storage::dataRequestQueue;
QMap<uint,QVariant> Storage::dataPool;

static int db_init(void *pNotUsed,int argc,char **argv,char **columnName) {
    Q_UNUSED(pNotUsed)
    Q_UNUSED(argc)
    Q_UNUSED(argv)
    Q_UNUSED(columnName)
    return 0;
}

static int db_fetch(void*, int argc, char *argv[], char *columnName[]) {
    QVariantMap rowMap;
    for(int i = 0; i < argc; ++i) {
        const QString key = QString::fromUtf8(columnName[i]);
        const QString val = QString::fromUtf8(argv[i]);
        rowMap.insert(key,val);
    }
    if(!rowMap.isEmpty()) {
        QVariantList dataLst = Storage::getDataPool().value(Storage::currentRequestId()).toList();
        dataLst.append(rowMap);
        Storage::getDataPool().insert(Storage::currentRequestId(),dataLst);
    }
    return 0;
}

static int query(const QString &sqlStr, int(*callback)(void*,int,char**,char**), void *callback_arg = nullptr) {
    int rc = SQLITE_ERROR;
    if(db) {
        char *pErrMsg = nullptr;
        rc = sqlite3_exec(db,sqlStr.toStdString().c_str(),callback,callback_arg,&pErrMsg);
        if(rc != SQLITE_OK) {
            std::cout << ">> Storage query error:" << pErrMsg << std::endl;
            std::cout.flush();
            sqlite3_free(pErrMsg);
        }
    }
    return rc;
}

/*!
 * \class Storage
 * \brief Storage实现本地数据存储，以及运行时数据缓存.
 * \param parent
 */
Storage::Storage(const QString &dataPath, QObject *parent)
    : QObject(parent)
{
    int rc = sqlite3_open(dataPath.toStdString().c_str(),&db);
    if(rc != SQLITE_OK) {
        std::cout << ">> sqlite3 open error: " << rc << ": " << sqlite3_errmsg(db) << std::endl;
        std::cout.flush();
        sqlite3_close(db);
        db = nullptr;
    }

    rc = query("CREATE TABLE IF NOT EXISTS appinfo("
               "id INTEGER PRIMARY KEY ASC,"
               "ver TEXT,"
               "dt TEXT,"
               "log TEXT);"
               "CREATE TABLE IF NOT EXISTS datas("
               "id INTEGER PRIMARY KEY ASC,"
               "content TEXT,"
               "dt TEXT);", db_init);
}

Storage::~Storage()
{
    if(db) {
        sqlite3_close(db);
        db = nullptr;
    }
}

QVector<uint> &Storage::getDataRequestQueue()
{
    return dataRequestQueue;
}

QMap<uint, QVariant> &Storage::getDataPool()
{
    return dataPool;
}

QVariantList Storage::appInfo()
{
    uint requestId = prepareRequest();
    query("SELECT * FROM appinfo WHERE id = (SELECT MAX(id) FROM appinfo);", db_fetch);
    return finishRequest(requestId).toList();
}

QVariantList Storage::loadData()
{
    uint requestId = prepareRequest();
    query("SELECT * FROM datas;", db_fetch);
    return finishRequest(requestId).toList();
}

void Storage::saveData(const QVariantMap &rowMap)
{
    sqlite3_stmt *stmt = nullptr;
    const QString rowId = rowMap.value("id").toString();
    if(rowId.isEmpty()) {
        sqlite3_prepare_v2(db,"INSERT INTO datas(content,dt,mdt) VALUES(?,datetime('now','localtime','utc'),datetime('now','localtime','utc'));",-1,&stmt,nullptr);
    } else {
        sqlite3_prepare_v2(db,"UPDATE datas SET mdt = datetime('now','localtime','utc'), content = ? WHERE id = ?;",-1,&stmt,nullptr);
        sqlite3_bind_int(stmt,2,rowId.toInt());
    }

    sqlite3_bind_text(stmt,1,rowMap.value("content").toString().toUtf8().data(),-1,nullptr);

    int rc = sqlite3_step(stmt);
    if(SQLITE_OK != rc || SQLITE_DONE != rc) {
        std::cout << rc << "cxbase::Storage::saveData: " << sqlite3_errmsg(db) << std::endl;
        std::cout.flush();
    }

    sqlite3_finalize(stmt);
}

}
