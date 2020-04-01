#include "liststoragemodel.h"
#include <QCoreApplication>
#include <QDir>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <cxbase/cxbase.h>
#include <andy-core/localstorage.h>
#include <QDebug>

ListStorageModel::ListStorageModel(QObject *parent)
    : QAbstractListModel(parent)
{
    LocalStorage *storage = LocalStorage::instance();
    QObject::connect(storage->storage(), SIGNAL(dataLoaded(const QVariantList&)), this, SLOT(onDataLoaded(const QVariantList&)));
    QObject::connect(storage->storage(),SIGNAL(dataCreated()),this,SLOT(refresh()));
    QObject::connect(storage->storage(),SIGNAL(dataRemoved()),this,SLOT(refresh()));
    QObject::connect(storage->storage(),SIGNAL(dataAltered()),this,SLOT(refresh()));

    QMetaObject::invokeMethod(storage->storage(),
                              "initDatabase",
                              Q_ARG(const QString&,storage->localStorageFilePath()));
}

ListStorageModel::~ListStorageModel()
{
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
    // emit LocalStorage::self().loadData();
    QMetaObject::invokeMethod(LocalStorage::self().storage(),
                              "loadDataList",
                              Qt::QueuedConnection);
}

void ListStorageModel::appendRow(const QVariantMap &row)
{
    const QString content = row.value("content").toString();
    QVariantMap data = row;
    data.insert("content",cx::CxBase::encryptText(content,mPassword));
    // emit LocalStorage::self().createData(data);
    QMetaObject::invokeMethod(LocalStorage::self().storage(),
                              "createData",
                              Q_ARG(const QVariantMap&,data));
    refresh();
}

void ListStorageModel::removeRow(const QString &uid)
{
    // emit LocalStorage::self().removeData(uid);
    QMetaObject::invokeMethod(LocalStorage::self().storage(),
                              "removeData",
                              Q_ARG(const QString&,uid));
}

void ListStorageModel::setProperty(const QString &uid, const QString &key, const QVariant &val)
{
    QVariant d = val;
    if (key == "content") {
        d = cx::CxBase::encryptText(d.toString(),mPassword);
    }
    // emit LocalStorage::self().alterData(uid,key,d);
    QMetaObject::invokeMethod(LocalStorage::self().storage(),
                              "alterData",
                              Q_ARG(const QString&,uid),Q_ARG(const QString&,key),Q_ARG(const QVariant&,d));
}

void ListStorageModel::setPassword(const QString &ps)
{
    mPassword = ps;
}

void ListStorageModel::onDataLoaded(const QVariantList &dataLst)
{
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
