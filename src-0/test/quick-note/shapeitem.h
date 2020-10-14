#ifndef SHAPEITEM_H
#define SHAPEITEM_H

#include <QQuickItem>

class ShapeItem : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(QVariantList vertices WRITE setVertices)
signals:
    void colorChanged(const QColor &c);
    void verticesChanged(const QVector<QPointF> &v, const int idx);

public:
    explicit ShapeItem(QQuickItem *parent = nullptr);

    void setColor(const QColor &c);
    const QColor &color() const;

    void setVertices(const QVariantList &v);
    QPointF vertex(const int idx) const;

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode,
                             QQuickItem::UpdatePaintNodeData *updatePaintNodeData) override;

private:
    QColor mColor;
    QVector<QPointF> mVertices;
};

Q_DECLARE_METATYPE(QPoint)

#endif // SHAPEITEM_H
