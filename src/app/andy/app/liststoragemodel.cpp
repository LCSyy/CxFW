#include "liststoragemodel.h"
#include <QCoreApplication>
#include <QDir>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <andy-core/localstorage.h>

#include <QDebug>

namespace {
void initDatabase() {
    QDir dir(qApp->applicationDirPath());
    const QString relativeLocalDB{"../common/localdb"};
    if (!dir.cd(relativeLocalDB)) {
        dir.mkdir(relativeLocalDB);
        dir.cd(relativeLocalDB);
    }

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dir.absoluteFilePath("andy-app.db"));
    if (!db.open()) {
        qDebug() << "[ERROR] local database connection error";
    } else {
        QSqlQuery query(db);
        query.exec("CREATE TABLE IF NOT EXISTS andy_app(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT, create_time TEXT);");
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
    query.prepare("INSERT INTO andy_app(content,create_time) VALUES(?,datetime('now','localtime'));");
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
    query.prepare(QString("UPDATE andy_app SET %1 = ? WHERE id = ?;").arg(key));
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
    QVariantList dataLst;
    while (query.next()) {
        QVariantMap dataMap;
        dataMap.insert("uid",query.value(idIdx));
        dataMap.insert("content",query.value(contentIdx));
        dataMap.insert("createTime",query.value(createTimeIdx));
        dataLst.append(dataMap);
    }
    qDebug() << "[SELECT] size:" << dataLst.size();
    return dataLst;
}
}

ListStorageModel::ListStorageModel(QObject *parent)
    : QAbstractListModel(parent)
{
    initDatabase();
    refresh();
}

ListStorageModel::~ListStorageModel()
{
    destroyDatabase();
}

QHash<int, QByteArray> ListStorageModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Index] = "index";
    roles[Uid] = "uid";
    roles[Content] = "content";
    roles[CreateTime] = "createTime";
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
    }
    return QVariant();
}

void ListStorageModel::refresh()
{
    beginResetModel();
    mContents.clear();
    endResetModel();

    const QVariantList dataLst = db_selectData();
    beginInsertRows(QModelIndex(),0,dataLst.size()-1);
    for (const QVariant &row: dataLst) {
        const QVariantMap rowMap = row.toMap();
        Row r;
        r.uid = rowMap.value("uid").toString();
        r.content = rowMap.value("content").toString();
        r.createTime = rowMap.value("createTime").toString();
        mContents.append(r);
    }
    endInsertRows();
}

void ListStorageModel::appendRow(const QVariantMap &row)
{
    db_createData(row);
    refresh();
}

void ListStorageModel::removeRow(const QString &uid)
{
    db_removeData(uid);
    refresh();
}

void ListStorageModel::setProperty(const QString &uid, const QString &key, const QVariant &val)
{
    db_alterData(uid,key,val);
    refresh();
}
