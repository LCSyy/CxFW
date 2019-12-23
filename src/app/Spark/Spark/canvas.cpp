#include "canvas.h"
#include <QPainter>
#include <QColor>
#include <QBrush>

Canvas::Canvas(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , d(new CanvasData)
{
    setRenderTarget(QQuickPaintedItem::FramebufferObject);
}

void Canvas::paint(QPainter *painter)
{
    painter->setPen(QPen(d->penColor));
    painter->drawLines(d->lines);
    painter->drawLine(d->curLine);
}

QColor Canvas::penColor() const
{
    return d->penColor;
}

void Canvas::setPenColor(const QColor &color)
{
    if(color != d->penColor) {
        d->penColor = color;
    }
}

void Canvas::startPaint()
{
    d->startPaint = true;
}

void Canvas::stopPaint()
{
    d->lines.append(d->curLine);
    d->startPaint = false;
}

void Canvas::drawLine(const QPoint &start, const QPoint &stop)
{
    d->curLine.setP1(start);
    d->curLine.setP2(stop);
    update();
}
