#include "canvas_shape.h"

#include <QDebug>

namespace {
QRect points2Rect(const QPoint &p1, const QPoint &p2) {
    int x1 = p1.x();
    int x2 = p2.x();

    int y1 = p1.y();
    int y2 = p2.y();
    if(p1.x() <= p2.x()) {
        x1 = p1.x();
        x2 = p2.x();
    } else {
        x1 = p2.x();
        x2 = p1.x();
    }

    if(p1.y() <= p2.y()) {
        y1 = p1.y();
        y2 = p2.y();
    } else {
        y1 = p2.y();
        y2 = p1.y();
    }
    return QRect(QPoint(x1,y1),QPoint(x2,y2));
}
}

CanvasShape::CanvasShape()
    : d(new CanvasShapeData)
{

}

CanvasShape::~CanvasShape()
{
}

void CanvasShape::setStartPoint(const QPoint &p)
{
    d->start = p;
}

const QPoint &CanvasShape::startPoint() const
{
    return d->start;
}

void CanvasShape::setStopPoint(const QPoint &p)
{
    d->stop = p;
}

const QPoint &CanvasShape::stopPoint() const
{
    return d->stop;
}

const QColor &CanvasShape::color() const
{
    return d->penColor;
}

void CanvasShape::setColor(const QColor &color)
{
    d->penColor = color;
}

LineCanvasShape::LineCanvasShape()
    : CanvasShape()
{

}

LineCanvasShape::~LineCanvasShape()
{

}

void LineCanvasShape::paint(QPainter *painter)
{
    painter->save();
    painter->setPen(d->penColor);
    painter->drawLine(startPoint(),stopPoint());
    painter->restore();
}

RectCanvasShape::RectCanvasShape()
    : CanvasShape()
{

}

RectCanvasShape::~RectCanvasShape()
{

}

void RectCanvasShape::paint(QPainter *painter)
{
    painter->save();
    painter->setPen(d->penColor);
    painter->drawRect(points2Rect(startPoint(),stopPoint()));
    painter->restore();
}

EllipseCanvasShape::EllipseCanvasShape()
    : CanvasShape()
{

}

EllipseCanvasShape::~EllipseCanvasShape()
{

}

void EllipseCanvasShape::paint(QPainter *painter)
{
    painter->save();
    painter->setPen(d->penColor);
    painter->drawEllipse(points2Rect(startPoint(),stopPoint()));
    painter->restore();
}
