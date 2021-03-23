#include "cxlistmodel.h"
#include <QDebug>

CxListModel::CxListModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

void CxListModel::setRoleNames(const QStringList &rs)
{
    m_roleNames.clear();
    for (int i = 0; i < rs.length(); ++i) {
        const int r =Qt::UserRole + i + 1;
        m_roleNames.insert(r, QByteArray().append(rs[i].toUtf8()));
    }
}

QHash<int, QByteArray> CxListModel::roleNames() const
{
    return m_roleNames;
}

int CxListModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return count();
}

QVariant CxListModel::data(const QModelIndex &index, int role) const
{
    const int row = index.row();
    if (row < 0 || rowCount() <= row) {
        return QVariant();
    }

    const QHash<int,QVariant> &ele = m_datas[row];
    return ele.value(role);
}

void CxListModel::append(const QVariantMap &ele)
{
    QHash<int,QVariant> e;
    beginInsertRows(QModelIndex(),count(),count());
    QMapIterator<QString,QVariant> iter(ele);
    while (iter.hasNext()) {
        iter.next();
        const int r = roleFromName(iter.key());
        if (r != 0) { e.insert(r,iter.value()); }
    }
    m_datas.append(e);
    endInsertRows();
}

int CxListModel::count() const
{
    return m_datas.size();
}

QVariant CxListModel::get(int idx) const
{
    QVariantMap ele;
    if (idx < 0 || count() <= idx) { return QVariant(); }
    const QHash<int,QVariant> &e = m_datas[idx];
    QHashIterator<int,QVariant> iter(e);
    while (iter.hasNext()) {
        iter.next();
        ele.insert(m_roleNames[iter.key()],iter.value());
    }
    return ele;
}

void CxListModel::set(int idx, const QString &prop, const QVariant &val)
{
    if (idx < 0 || count() <= idx) { return; }

    QHash<int,QVariant> &e = m_datas[idx];
    const int role = roleFromName(prop);
    if (role == 0) { return; }
    e[role] = val;

    emit dataChanged(index(idx),index(idx),QVector<int>{role});
}

void CxListModel::insert(int idx, const QVariantMap &map)
{
    beginInsertRows(QModelIndex(), idx, idx);
    QHash<int,QVariant> e;
    QMapIterator<QString,QVariant> iter(map);
    while (iter.hasNext()) {
        iter.next();
        const int r = roleFromName(iter.key());
        if (r != 0) { e.insert(r,iter.value()); }
    }
    m_datas.insert(idx,e);
    endInsertRows();
}

void CxListModel::remove(int idx)
{
    if (idx < 0 || count() <= idx) { return; }

    beginRemoveRows(QModelIndex(),idx, idx);
    m_datas.removeAt(idx);
    endRemoveRows();
}

void CxListModel::move(int from, int to)
{
    Q_UNUSED(from)
    Q_UNUSED(to)
}

void CxListModel::clear()
{
    beginResetModel();
    m_datas.clear();
    endResetModel();
}

int CxListModel::roleFromName(const QString &name) const
{
    const QByteArray ba = QByteArray().append(name.toUtf8());
    for (auto iter = m_roleNames.begin(); iter != m_roleNames.end(); ++iter) {
        if (iter.value() == ba) {
            return iter.key();
        }
    }
    return 0;
}
