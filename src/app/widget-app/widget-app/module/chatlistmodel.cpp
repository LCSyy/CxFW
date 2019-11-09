#include "chatlistmodel.h"
#include <QFontMetrics>
#include <QApplication>

ChatListModel::ChatListModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

int ChatListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return mChatDataLst.size();
}

QVariant ChatListModel::data(const QModelIndex &index,
                             int role) const
{
    if(!index.isValid()) { return QVariant(); }
    const QVariantMap rowMap = mChatDataLst.value(index.row()).toMap();

    switch(role){
    case Qt::DisplayRole:
        return QVariant::fromValue(rowMap.value("msg"));
    case Qt::SizeHintRole:
        const QString msg  = rowMap.value("msg").toString();
        QFontMetrics metrics(qApp->font());
        return metrics.boundingRect(QRect(0,0,600,600), Qt::AlignLeft | Qt::TextWrapAnywhere, msg).size();
    }
    return QVariant();
}

/*!
 * \brief ChatListModel::appendChatMsg
 * \param msg
 * \code
 * {
 *   "user":"",
 *   "msg":""
 * }
 * \endcode
 */
void ChatListModel::appendChatMsg(const QVariantMap &msg)
{
    beginInsertRows(QModelIndex(),rowCount(),rowCount());
    mChatDataLst.append(msg);
    endInsertRows();
}

