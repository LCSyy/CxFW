#ifndef LISTMODEL_H
#define LISTMODEL_H

#include <QObject>
#include <QAbstractListModel>

class ListElement {
    Q_GADGET
public:
    ~ListElement();

    enum Roles {
        IdRole = Qt::UserRole + 1,
        UuidRole,
        TitleRole,
        ContentRole,
        TagsRole,
        CreateRole,
        UpdateRole,
    };

    long long m_id;
    QString m_uuid;
    QString m_title;
    QString m_content;
    QStringList m_tags;
    QString m_create_dt;
    QString m_update_dt;

    QVariantMap toMap() const;

    static QHash<int,QByteArray> roleNames();
    static ListElement fromMap(const QVariantMap &map);
};

class ListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit ListModel(QObject *parent = nullptr);

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

private:
    QList<ListElement> m_datas;
};

#endif // LISTMODEL_H
