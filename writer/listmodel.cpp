#include "listmodel.h"

ListElement::~ListElement()
{

}

QVariantMap ListElement::toMap() const
{
    QVariantMap map;
    map.insert("id",m_id);
    map.insert("uuid",m_uuid);
    map.insert("title",m_title);
    map.insert("content",m_content);
    map.insert("tags",m_tags);
    map.insert("create_dt",m_create_dt);
    map.insert("update_dt", m_update_dt);
    return map;
}

QHash<int, QByteArray> ListElement::roleNames()
{
    QHash<int,QByteArray> roles;
    roles[IdRole]      = "id";
    roles[UuidRole]    = "uuid";
    roles[TitleRole]   = "title";
    roles[ContentRole] = "content";
    roles[TagsRole]    = "tags";
    roles[CreateRole]  = "create_dt";
    roles[UpdateRole]  = "update_dt";
    return roles;
}

ListElement ListElement::fromMap(const QVariantMap &map)
{
    ListElement e;
    e.m_id = map.value("id",0).toLongLong();
    e.m_uuid = map.value("uuid").toString();
    e.m_title = map.value("title").toString();
    e.m_content = map.value("content").toString();
    e.m_tags = map.value("tags",QStringList{}).toStringList();
    e.m_create_dt = map.value("create_dt").toString();
    e.m_update_dt = map.value("update_dt").toString();
    return e;
}

ListModel::ListModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

QHash<int, QByteArray> ListModel::roleNames() const
{
    return ListElement::roleNames();
}

int ListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return count();
}

QVariant ListModel::data(const QModelIndex &index, int role) const
{
    const int row = index.row();
    if (row < 0 || rowCount() <= row) {
        return QVariant();
    }

    const ListElement &ele = m_datas[row];

    const ListElement::Roles r = static_cast<ListElement::Roles>(role);
    switch (r) {
    case ListElement::IdRole: return QVariant::fromValue(ele.m_id);
    case ListElement::UuidRole: return QVariant::fromValue(ele.m_uuid);
    case ListElement::TitleRole: return QVariant::fromValue(ele.m_title);
    case ListElement::ContentRole: return QVariant::fromValue(ele.m_content);
    case ListElement::TagsRole:   return QVariant::fromValue(ele.m_tags);
    case ListElement::CreateRole: return QVariant::fromValue(ele.m_create_dt);
    case ListElement::UpdateRole: return QVariant::fromValue(ele.m_update_dt);
    }
    return QVariant();
}

void ListModel::append(const QVariantMap &ele)
{
    beginInsertRows(QModelIndex(),count(),count());
    m_datas.append(ListElement::fromMap(ele));
    endInsertRows();
}

int ListModel::count() const
{
    return m_datas.size();
}

QVariant ListModel::get(int idx) const
{
    if (idx < 0 || count() <= idx) { return QVariant(); }
    return m_datas[idx].toMap();
}

void ListModel::insert(int idx, const QVariantMap &map)
{
    beginInsertRows(QModelIndex(), idx, idx);
    m_datas.insert(idx,ListElement::fromMap(map));
    endInsertRows();
}

void ListModel::set(int idx, const QVariantMap &map)
{
    if (idx < 0 || count() <= idx) { return; }
    m_datas[idx] = ListElement::fromMap(map);

    const QModelIndex i = index(idx);
    emit dataChanged(i,i,QVector<int>{
                         ListElement::IdRole,
                         ListElement::UuidRole,
                         ListElement::TitleRole,
                         ListElement::ContentRole,
                         ListElement::TagsRole,
                         ListElement::CreateRole,
                         ListElement::UpdateRole});
}

void ListModel::move(int from, int to)
{
    Q_UNUSED(from)
    Q_UNUSED(to)
}

void ListModel::clear()
{
    beginResetModel();
    m_datas.clear();
    endResetModel();
}
