#ifndef LISTSTORAGEMODEL_H
#define LISTSTORAGEMODEL_H

#include <QAbstractListModel>

class ListStorageModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit ListStorageModel(QObject *parent = nullptr);
    ~ListStorageModel() override;

    struct Row{
        QString uid;
        QString content;
    };

    enum ContentRole {
        Index = Qt::UserRole + 1,
        Uid,
        Content
    };

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool removeRows(int row, int count, const QModelIndex &parent = QModelIndex()) override;

public slots:
    void appendRow(const QVariantMap &row);
    void removeRow(int row);
    void setProperty(int row, const QString &key, const QVariant &val);

private:
    QList<Row> mContents;
};

#endif // LISTSTORAGEMODEL_H
