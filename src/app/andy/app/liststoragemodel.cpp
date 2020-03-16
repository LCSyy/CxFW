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
    roles[Uid] = "uid";
    roles[Content] = "content";
    return roles;
}

int ListStorageModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return 0;
}

QVariant ListStorageModel::data(const QModelIndex &index, int role) const
{
    Q_UNUSED(index)
    Q_UNUSED(role)
    return QVariant();
}
