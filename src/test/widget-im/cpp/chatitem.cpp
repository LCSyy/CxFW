#include "chatitem.h"
#include <QPainter>
#include <QBrush>
#include <QGuiApplication>

ChatItem::ChatItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , mMsgMetrics(qGuiApp->font())
{
}

void ChatItem::paint(QPainter *painter)
{
    QSize textSize = mMsgMetrics.boundingRect(mMsgText).size();
    int w = static_cast<int>(width());
    setHeight(textSize.height() >= 45 ? textSize.height() : 45);

    QBrush brush;
    brush.setStyle(Qt::SolidPattern);
    brush.setColor(QColor("#123789"));
    if(mMsgSide == 0) {
        painter->fillRect(0,0,30,30,brush);
        painter->fillRect(0,35,30,10,brush);
        painter->fillRect(40,0,textSize.width() + 10,textSize.height(),brush);
        painter->drawText(QPointF(50,10),mMsgText);
    } else {
        painter->fillRect(w-30,0,30,30,brush);
        painter->fillRect(w-30,35,30,10,brush);
        painter->fillRect(w-50-textSize.width(),0,textSize.width()+10,textSize.height(),brush);
        painter->drawText(QPointF(w - 50 - textSize.width(),10),mMsgText);
    }
}

void ChatItem::setText(const QString &text)
{
    if(mMsgText != text) {
        mMsgText = text;
        emit textChanged(mMsgText);
    }
}

void ChatItem::setSide(int side)
{
    if(mMsgSide != side) {
        mMsgSide = side;
        emit sideChanged(mMsgSide);
    }
}
