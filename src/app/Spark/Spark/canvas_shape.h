#ifndef CANVASSHAPE_H
#define CANVASSHAPE_H

#include <QScopedPointer>
#include <QPainter>
#include <QColor>
#include <QPolygon>
#include <QPoint>
#include <QLine>

struct CanvasShapeData {
    QColor penColor;
    QPoint start;
    QPoint stop;
};

class CanvasShape
{
public:
    CanvasShape();
    virtual ~CanvasShape();

    virtual void paint(QPainter *painter) = 0;

    virtual void setStartPoint(const QPoint &p);
    const QPoint &startPoint() const;

    virtual void setStopPoint(const QPoint &p);
    const QPoint &stopPoint() const;

    const QColor &color() const;
    void setColor(const QColor &color);

protected:
    QScopedPointer<CanvasShapeData> d;
};

class LineCanvasShape: public CanvasShape
{
public:
    LineCanvasShape();
    ~LineCanvasShape() override;

    void paint(QPainter *painter) override;
};

class RectCanvasShape: public CanvasShape
{
public:
    RectCanvasShape();
    ~RectCanvasShape() override;

    void paint(QPainter *painter) override;
};

class EllipseCanvasShape: public CanvasShape
{
public:
    EllipseCanvasShape();
    ~EllipseCanvasShape() override;

    void paint(QPainter *painter) override;
};

class PolylineCanvasShape: public CanvasShape
{
public:
    PolylineCanvasShape();
    ~PolylineCanvasShape() override;

    void paint(QPainter *painter) override;

    void setStartPoint(const QPoint &p) override;
    void setStopPoint(const QPoint &p) override;

protected:
    QPolygon polyline;
};

#endif // CANVASSHAPE_H
