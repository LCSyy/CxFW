#ifndef CANVAS_H
#define CANVAS_H

#include <QQuickPaintedItem>
#include <QLine>

class CanvasShape;

struct CanvasData
{
    ~CanvasData();

    bool startPaint {false};
    QColor penColor;
    CanvasShape *currentShape {nullptr};
    QString shapeType;
    QVector<CanvasShape*> shapes;
};

class Canvas : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString shapeType READ shapeType WRITE setShapeType)
    Q_PROPERTY(QColor penColor READ penColor WRITE setPenColor)
public:
    Canvas(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

    const QString &shapeType() const;
    void setShapeType(const QString &sh);

    const QColor &penColor() const;
    void setPenColor(const QColor &color);

    Q_INVOKABLE void startPaint(const QPoint &point);
    Q_INVOKABLE void stopPaint();

public slots:
    void draw(const QPoint &stop);

private:
    CanvasShape *createShape(const QString &type);

private:
    QScopedPointer<CanvasData> d;
};

#endif // CANVAS_H
