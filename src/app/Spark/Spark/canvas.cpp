#include "canvas.h"
#include <QPainter>
#include <QColor>
#include <QBrush>
#include "canvas_shape.h"

#include <QDebug>

CanvasData::~CanvasData()
{
    qDeleteAll(shapes);
    shapes.clear();
}

Canvas::Canvas(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , d(new CanvasData)
{
    d->shapeType = "line";
    setRenderTarget(QQuickPaintedItem::FramebufferObject);
}

void Canvas::paint(QPainter *painter)
{
    Q_UNUSED(painter)

    for(CanvasShape *shape: d->shapes) {
        if(shape) {
            shape->paint(painter);
        }
    }

    if(d->currentShape) {
        d->currentShape->paint(painter);
    }
}

const QString &Canvas::shapeType() const
{
    return d->shapeType;
}

void Canvas::setShapeType(const QString &sh)
{
    if(sh != d->shapeType) {
        d->shapeType = sh;
    }
}

const QColor &Canvas::penColor() const
{
    return d->penColor;
}

void Canvas::setPenColor(const QColor &color)
{
    if(color != d->penColor) {
        d->penColor = color;
    }
}

void Canvas::startPaint(const QPoint &point)
{
    d->startPaint = true;

    d->currentShape = createShape(d->shapeType);

    if(d->currentShape) {
        d->currentShape->setColor(d->penColor);
        d->currentShape->setStartPoint(point);
    }
}

void Canvas::stopPaint()
{
    d->startPaint = false;
    if(d->currentShape) {
        d->shapes.append(d->currentShape);
        d->currentShape = nullptr;
    }
}

void Canvas::draw(const QPoint &stop)
{
    if(d->currentShape) {
        d->currentShape->setStopPoint(stop);
        update();
    }
}

CanvasShape *Canvas::createShape(const QString &type)
{
    if(type == QLatin1Literal("line")) {
        return new LineCanvasShape;
    } else if(type == QLatin1Literal("rect")) {
        return new RectCanvasShape;
    } else if(type == QLatin1Literal("ellipse")) {
        return new EllipseCanvasShape;
    } else if(type == QLatin1Literal("polyline")) {
        return new PolylineCanvasShape;
    } else {
        return nullptr;
    }
}

