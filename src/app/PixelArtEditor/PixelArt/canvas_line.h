#ifndef CANVASLINE_H
#define CANVASLINE_H

#include "PixelArt_global.h"
#include <QQuickItem>

class PIXELART_EXPORT CanvasLine : public QQuickItem
{
    Q_OBJECT
public:
    explicit CanvasLine(QQuickItem *parent = nullptr);
    ~CanvasLine() override;

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *updatePaintNodeData) override;

};

#endif // CANVASLINE_H
