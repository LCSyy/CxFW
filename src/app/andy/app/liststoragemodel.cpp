#include "liststoragemodel.h"

ListStorageModel::ListStorageModel(QObject *parent)
    : QAbstractListModel(parent)
{

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
    }
    return QVariant();
}

bool ListStorageModel::removeRows(int row, int count, const QModelIndex &parent)
{
    bool removeOk{false};
    if (row >= 0 && row + (count-1) < mContents.size()) {
        beginRemoveRows(parent,row,row+(count-1));
        for (int i = 0; i < count; ++i) {
            mContents.removeAt(row);
            removeOk = true;
        }
        endRemoveRows();
    }
    return removeOk;
}

void ListStorageModel::appendRow(const QVariantMap &row)
{
    Row r;
    r.uid = row.value("uid").toString();
    r.content = row.value("content").toString();

    beginInsertRows(QModelIndex(),rowCount(),rowCount());
    mContents.append(r);
    endInsertRows();
}

void ListStorageModel::removeRow(int row)
{
    removeRows(row,1,QModelIndex());
}

void ListStorageModel::setProperty(int row, const QString &key, const QVariant &val)
{
    Q_UNUSED(key)
    if (row < mContents.size()) {
        mContents[row].content = val.toString();
        emit dataChanged(index(row,0),index(row,0),QVector<int>{Content});
    }
}
