#ifndef CHATMSGMODEL_H
#define CHATMSGMODEL_H

#include <QAbstractListModel>

enum class ChatItemRole {
    UserWhoRole = Qt::UserRole + 1,
    UserColorRole,
    UserNameRole,
    MsgTimeRole,
    MsgContentRole
};

class ChatMsgModel: public QAbstractListModel
{
    Q_OBJECT
public:
    ChatMsgModel(QObject *parent = nullptr);
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int,QByteArray> roleNames() const override;

    void addMessage(const QVariantMap &chatMsg);

private:
    QVariantList mMsgLst;
};

#endif // CHATMSGMODEL_H
