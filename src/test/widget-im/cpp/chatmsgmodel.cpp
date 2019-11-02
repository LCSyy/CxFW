#include "chatmsgmodel.h"
#include <QHash>

ChatMsgModel::ChatMsgModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

int ChatMsgModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return mMsgLst.size();
}

QVariant ChatMsgModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() >= mMsgLst.count())
        return QVariant();

    const QVariantMap rowMap = mMsgLst.value(index.row()).toMap();
    QVariant ret;
    switch(static_cast<ChatItemRole>(role)) {
    case ChatItemRole::UserWhoRole:
        ret = QVariant::fromValue(rowMap.value("who"));
        break;
    case ChatItemRole::UserColorRole:
        ret = QVariant::fromValue(rowMap.value("color"));
        break;
    case ChatItemRole::UserNameRole:
        ret = QVariant::fromValue(rowMap.value("name"));
        break;
    case ChatItemRole::MsgTimeRole:
        ret = QVariant::fromValue(rowMap.value("dt"));
        break;
    case ChatItemRole::MsgContentRole:
        ret = QVariant::fromValue(rowMap.value("msg"));
        break;
    }
    return ret;
}

QHash<int, QByteArray> ChatMsgModel::roleNames() const
{
    QHash<int, QByteArray> roles;
      roles[static_cast<int>(ChatItemRole::UserWhoRole)] = "who";
      roles[static_cast<int>(ChatItemRole::UserColorRole)] = "color";
      roles[static_cast<int>(ChatItemRole::UserNameRole)] = "name";
      roles[static_cast<int>(ChatItemRole::MsgTimeRole)] = "dt";
      roles[static_cast<int>(ChatItemRole::MsgContentRole)] = "msg";
      return roles;
}

void ChatMsgModel::addMessage(const QVariantMap &chatMsg)
{
    int rowCount = mMsgLst.size();
    beginInsertRows(QModelIndex(),rowCount,rowCount);
    mMsgLst.append(chatMsg);
    endInsertRows();
    emit addItem(rowCount);
}
