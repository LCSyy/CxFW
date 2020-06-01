#include "trendsboardmodel.h"

TrendsBoardItem::TrendsBoardItem(qint64 uid, const QString &name, const QString &title, const QString &brief)
    : m_uid(uid)
    , m_name(name)
    , m_title(title)
    , m_brief(brief)
{

}

TrendsBoardItem::TrendsBoardItem(const TrendsBoardItem &other)
    : m_uid(other.m_uid)
    , m_name(other.m_name)
    , m_title(other.m_title)
    , m_brief(other.m_brief)
{

}

TrendsBoardItem::TrendsBoardItem(TrendsBoardItem &&other)
    : m_uid(other.m_uid)
    , m_name(other.m_name)
    , m_title(other.m_title)
    , m_brief(other.m_brief)
{

}

TrendsBoardItem &TrendsBoardItem::operator=(const TrendsBoardItem &other)
{
    m_uid = other.m_uid;
    m_name = other.m_name;
    m_title = other.m_title;
    m_brief = other.m_brief;
    return *this;
}

TrendsBoardItem &TrendsBoardItem::operator=(TrendsBoardItem &&other)
{
    m_uid = other.m_uid;
    m_name = other.m_name;
    m_title = other.m_title;
    m_brief = other.m_brief;
    return *this;
}

QVariant TrendsBoardItem::role2ItemData(ItemRole role) const
{
    QVariant ret;
    switch (role) {
    case Uid:
        ret.setValue(uid());
        break;
    case Name:
        ret.setValue(name());
        break;
    case Title:
        ret.setValue(title());
        break;
    case Brief:
        ret.setValue(brief());
    }
    return ret;
}

TrendsBoardModel::TrendsBoardModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

TrendsBoardModel::~TrendsBoardModel()
{

}

QHash<int, QByteArray> TrendsBoardModel::roleNames() const
{
    QHash<int,QByteArray> roles;
    roles[TrendsBoardItem::Uid] = "uid";
    roles[TrendsBoardItem::Name] = "name";
    roles[TrendsBoardItem::Title] = "title";
    roles[TrendsBoardItem::Brief] = "brief";
    return roles;
}

int TrendsBoardModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    return m_items.size();
}

QVariant TrendsBoardModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();
    if (row < 0 || row >= m_items.size()) {
        return QVariant();
    }

    return m_items[row].role2ItemData(static_cast<TrendsBoardItem::ItemRole>(role));
}

void TrendsBoardModel::pushTrends(QList<TrendsBoardItem> &&items)
{
    beginInsertRows(QModelIndex(), m_items.size(),m_items.size() + items.size() - 1);
    m_items.append(items);
    endInsertRows();
}
