#ifndef CHATLISTMODEL_H
#define CHATLISTMODEL_H

#include <QAbstractListModel>

class ChatListModel: public QAbstractListModel
{
    Q_OBJECT
public:
    ChatListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index,
                  int role = Qt::DisplayRole) const override;

    void appendChatMsg(const QVariantMap &msg);

private:
    QVariantList mChatDataLst;
};

#endif // CHATLISTMODEL_H
