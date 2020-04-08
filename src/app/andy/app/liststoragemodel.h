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
        QString createTime;
        QString modifyTime;
    };

    enum ContentRole {
        Index = Qt::UserRole + 1,
        Uid,
        Content,
        CreateTime,
        ModifyTime
    };

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

public slots:
    void refresh();
    void appendRow(const QVariantMap &row);
    void removeRow(const QString &uid);
    void setProperty(const QString &uid, const QString &key, const QVariant &val);
    void setPassword(const QString &ps);

private:
    QList<Row> mContents;
    QString mPassword;
};

#endif // LISTSTORAGEMODEL_H
