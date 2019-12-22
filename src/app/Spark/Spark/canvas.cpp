#include "canvas.h"
#include <QPainter>
#include <QColor>
#include <QBrush>

Canvas::Canvas(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setRenderTarget(QQuickPaintedItem::FramebufferObject);
}

void Canvas::paint(QPainter *painter)
{
    painter->setPen(QPen(QColor(123,234,56)));
    painter->drawRect(QRectF(10,10,width() - 20,height() - 20));
}
