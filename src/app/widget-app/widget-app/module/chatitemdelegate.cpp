#include "chatitemdelegate.h"
#include <QPainter>
#include <QDebug>

ChatItemDelegate::ChatItemDelegate(QObject *parent)
    : QStyledItemDelegate(parent)
{

}

void ChatItemDelegate::paint(QPainter *painter,
                             const QStyleOptionViewItem &option,
                             const QModelIndex &index) const
{
    if(index.isValid()) {
        QPainterPath path;

        QRect r = option.rect;
        painter->drawRect(r);

        QSize s = index.data(Qt::SizeHintRole).toSize();
        r.adjust(10,10,0,0);
        r.setWidth(s.width());
        r.setHeight(s.height());

        path.addRoundedRect(r,6,6);
        painter->fillPath(path,QColor("#258963"));

        painter->drawText(r, Qt::TextWrapAnywhere, index.data().toString());
    }
}

QSize ChatItemDelegate::sizeHint(const QStyleOptionViewItem &option,
                                 const QModelIndex &index) const
{
    Q_UNUSED(option)
    QSize s = index.data(Qt::SizeHintRole).toSize();
    return s + QSize(0,36);
}
