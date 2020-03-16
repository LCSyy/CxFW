#ifndef LISTSTORAGEMODEL_H
#define LISTSTORAGEMODEL_H

#include <QAbstractListModel>

class ListStorageModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit ListStorageModel(QObject *parent = nullptr);
    ~ListStorageModel() override;

    enum ContentRole {
        Uid = Qt::UserRole + 1,
        Content
    };

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
};

#endif // LISTSTORAGEMODEL_H
