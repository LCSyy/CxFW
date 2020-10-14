#ifndef TRENDSBOARDMODEL_H
#define TRENDSBOARDMODEL_H

#include <QtGlobal>
#include <QAbstractListModel>


class TrendsBoardItem {
public:
    TrendsBoardItem(qint64 uid, const QString &name, const QString &title, const QString &brief);
    TrendsBoardItem(const TrendsBoardItem &other);
    TrendsBoardItem(TrendsBoardItem &&other);

    enum ItemRole {
        Uid = Qt::UserRole + 1,
        Name,
        Title,
        Brief,
    };

    TrendsBoardItem &operator=(const TrendsBoardItem &other);
    TrendsBoardItem &operator=(TrendsBoardItem &&other);

    qint64 uid() const { return m_uid; }
    const QString &name() const { return m_name; }
    const QString &title() const { return m_title; }
    const QString &brief() const { return m_brief; }

    QVariant role2ItemData(ItemRole role) const;

private:
    qint64 m_uid;
    QString m_name;
    QString m_title;
    QString m_brief;
};

class TrendsBoardModel : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit TrendsBoardModel(QObject *parent = nullptr);
    ~TrendsBoardModel() override;

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    void pushTrends(QList<TrendsBoardItem> &&items);

private:
    QList<TrendsBoardItem> m_items;
};

#endif // TRENDSBOARDMODEL_H
