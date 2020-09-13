#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QObject>
#include <QAbstractListModel>

class ListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QStringList roleNames WRITE setRoleNames)
public:
    explicit ListModel(QObject *parent = nullptr);

    void setRoleNames(const QStringList &rs);
    QHash<int,QByteArray> roleNames() const override;

    int rowCount(const QModelIndex &parent=QModelIndex{}) const override;
    QVariant data(const QModelIndex &index, int role=Qt::DisplayRole) const override;

    Q_INVOKABLE void append(const QVariantMap &ele);
    Q_INVOKABLE int count() const;
    Q_INVOKABLE QVariant get(int idx) const;
    Q_INVOKABLE void insert(int idx, const QVariantMap &map);
    Q_INVOKABLE void set(int idx, const QVariantMap &map);
    Q_INVOKABLE void move(int from, int to);
    Q_INVOKABLE void clear();

protected:
    int roleFromName(const QString &name) const;

private:
    QList<QHash<int,QVariant>> m_datas;
    QHash<int,QByteArray> m_roleNames;
};

#endif // LISTMODEL_H
