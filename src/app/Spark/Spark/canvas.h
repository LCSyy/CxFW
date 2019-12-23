#ifndef CANVAS_H
#define CANVAS_H

#include <QQuickPaintedItem>
#include <QLine>

struct CanvasData
{
    bool startPaint {false};
    QLine curLine;
    QColor penColor;
    QVector<QLine> lines;
};

class Canvas : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QColor penColor READ penColor WRITE setPenColor)
public:
    Canvas(QQuickItem *parent = nullptr);

    void paint(QPainter *painter);

    QColor penColor() const;
    void setPenColor(const QColor &color);

    Q_INVOKABLE void startPaint();
    Q_INVOKABLE void stopPaint();
public slots:
    void drawLine(const QPoint &start, const QPoint &stop);

private:
    QScopedPointer<CanvasData> d;
};

#endif // CANVAS_H
