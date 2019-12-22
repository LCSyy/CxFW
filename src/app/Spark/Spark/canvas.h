#ifndef CANVAS_H
#define CANVAS_H

#include <QQuickPaintedItem>

class Canvas : public QQuickPaintedItem
{
    Q_OBJECT
public:
    Canvas(QQuickItem *parent = nullptr);

    void paint(QPainter *painter);

signals:

};

#endif // CANVAS_H
