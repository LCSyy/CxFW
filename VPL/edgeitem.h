#ifndef EDGEITEM_H
#define EDGEITEM_H

#include <QQuickItem>

class EdgeItem : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QColor color READ color WRITE setColor)
    Q_PROPERTY(QPointF startPoint READ startPoint WRITE setStartPoint)
    Q_PROPERTY(QPointF stopPoint READ stopPoint WRITE setStopPoint)
public:
    explicit EdgeItem(QQuickItem *parent = nullptr);
    ~EdgeItem() override;

    const QColor &color() const { return m_color; }
    const QPointF &startPoint() const { return m_startPoint; };
    const QPointF &stopPoint() const { return m_stopPoint; };

    void setColor(const QColor &c) {
        m_color = c;
    }
    void setStartPoint(const QPointF &p) {
        m_startPoint = p;
        updateGeometry();
    }
    void setStopPoint(const QPointF &p) {
        m_stopPoint = p;
        updateGeometry();
    }

signals:

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, UpdatePaintNodeData *data) override;
    void updateGeometry();

protected:
    QColor m_color;
    QPointF m_startPoint;
    QPointF m_stopPoint;
};

#endif // EDGEITEM_H
