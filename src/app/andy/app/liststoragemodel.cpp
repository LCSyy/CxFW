#include "liststoragemodel.h"
#include <QCoreApplication>
#include <QDir>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <cxbase/cxbase.h>
#include <andy-core/localstorage.h>
#include <QDebug>

namespace {
void initDatabase() {
    QDir dir(qApp->applicationDirPath());
    dir.cdUp();
    if (!dir.cd("common")) {
        dir.mkdir("common");
        dir.cd("common");
    }
    if (!dir.cd("localdb")) {
        dir.mkdir("localdb");
        dir.cd("localdb");
    }
    qDebug() << "localdb dir:" << dir.absolutePath();

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dir.absoluteFilePath("andy-app.db"));
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
                                                    "VALUES(%1,'%2',datetime('now','localtime'));").arg(1).arg("0.0.1");

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

void destroyDatabase() {
    QString connectionName;
    {
        QSqlDatabase db = QSqlDatabase::database();
        connectionName = db.connectionName();
        db.close();
    }
    QSqlDatabase::removeDatabase(connectionName);
}

// 增删查改
void db_createData(const QVariantMap &row) {
    qDebug() << "[CREATE]" << row;
    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.prepare("INSERT INTO andy_app(content,create_time,modify_time) VALUES(?,datetime('now','localtime'),datetime('now','localtime'));");
    query.addBindValue(row.value("content"));
    query.exec();
}

void db_removeData(const QString &id) {
    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.prepare("DELETE FROM andy_app WHERE id = ?;");
    query.addBindValue(id);
    query.exec();
    qDebug() << "[REMOVE] row:" << id;
}

void db_alterData(const QString &id, const QString &key, const QVariant &val) {
    QSqlDatabase db = QSqlDatabase::database();
    QSqlQuery query(db);
    query.prepare(QString("UPDATE andy_app SET %1 = ?, modify_time = datetime('now','localtime') WHERE id = ?;").arg(key));
    query.addBindValue(val);
    query.addBindValue(id);
    query.exec();
    qDebug() << "[ALTER] uid:" << id << "," << key << ":" << val;
}

QVariantList db_selectData() {
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
    return dataLst;
}

}

ListStorageModel::ListStorageModel(QObject *parent)
    : QAbstractListModel(parent)
    , storage(new LocalStorage(this))
{
    // initDatabase();
    // LocalStorage::self();

    // connect(LocalStorage::self(),&LocalStorage::storageInitialed,[](){ qDebug() << "Storage init."; });
    // connect(LocalStorage::self(), &LocalStorage::dataHasLoad, this, &ListStorageModel::onDataLoaded);
    // emit LocalStorage::instance().initStorage(LocalStorage::instance().localStorageFilePath());

    connect(storage, SIGNAL(dataHasLoad(const QVariantList&)), this, SLOT(onDataLoaded(const QVariantList&)));
    connect(storage,SIGNAL(dataCreated()),this,SLOT(refresh()));
    connect(storage,SIGNAL(dataRemoved()),this,SLOT(refresh()));
    connect(storage,SIGNAL(dataAltered()),this,SLOT(refresh()));

    emit storage->initStorage(storage->localStorageFilePath());
}

ListStorageModel::~ListStorageModel()
{
    // destroyDatabase();
    // LocalStorage::drop();
}

QHash<int, QByteArray> ListStorageModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Index] = "index";
    roles[Uid] = "uid";
    roles[Content] = "content";
    roles[CreateTime] = "createTime";
    roles[ModifyTime] = "modifyTime";
    return roles;
}

int ListStorageModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mContents.size();
}

QVariant ListStorageModel::data(const QModelIndex &index, int role) const
{
    const int row = index.row();
    const Row d = mContents.value(row);
    const ContentRole r = static_cast<ContentRole>(role);
    if (r == Index) {
        return row;
    } else if (r == Uid) {
        return d.uid;
    } else if (r == Content || Qt::DisplayRole == role) {
        return d.content;
    } else if (r == CreateTime) {
        return d.createTime;
    } else if (r == ModifyTime) {
        return d.modifyTime;
    }
    return QVariant();
}

void ListStorageModel::refresh()
{
    // emit LocalStorage::instance().loadData();
    emit storage->loadData();
}

void ListStorageModel::appendRow(const QVariantMap &row)
{
    const QString content = row.value("content").toString();
    QVariantMap data = row;
    data.insert("content",cx::CxBase::encryptText(content,mPassword));
    qDebug() << "[Content] " << content;
    // db_createData(data);
    emit storage->createData(data);
    refresh();
}

void ListStorageModel::removeRow(const QString &uid)
{
    // db_removeData(uid);
    // refresh();
    emit storage->removeData(uid);
}

void ListStorageModel::setProperty(const QString &uid, const QString &key, const QVariant &val)
{
    QVariant d = val;
    if (key == "content") {
        d = cx::CxBase::encryptText(d.toString(),mPassword);
    }
    // db_alterData(uid,key,d);
    // refresh();
    emit storage->alterData(uid,key,d);
}

void ListStorageModel::setPassword(const QString &ps)
{
    mPassword = ps;
}

void ListStorageModel::onDataLoaded(const QVariantList &dataLst)
{
    qDebug() << dataLst;

    beginResetModel();
    mContents.clear();
    endResetModel();

    // const QVariantList dataLst = db_selectData();
    if (dataLst.size() == 0) { return; }
    beginInsertRows(QModelIndex(),0,dataLst.size()-1);
    for (const QVariant &row: dataLst) {
        const QVariantMap rowMap = row.toMap();
        Row r;
        r.uid = rowMap.value("uid").toString();
        r.content = cx::CxBase::decryptText(rowMap.value("content").toString(),mPassword);
        r.createTime = rowMap.value("createTime").toString();
        r.modifyTime = rowMap.value("modifyTime").toString();
        mContents.append(r);
    }
    endInsertRows();
}
