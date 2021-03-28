#ifndef CURVEITEM_H
#define CURVEITEM_H

#include <QQuickPaintedItem>

class CurveItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QPointF startPoint READ startPoint WRITE setStartPoint)
    Q_PROPERTY(QPointF stopPoint READ stopPoint WRITE setStopPoint)
public:
    explicit CurveItem(QQuickItem *parent = nullptr);
    ~CurveItem() override;

    void paint(QPainter *p) override;

    const QPointF &startPoint() const { return m_startPoint; };
    const QPointF &stopPoint() const { return m_stopPoint; };

    void setStartPoint(const QPointF &p) {
        m_startPoint = p;
        updateGeometry();
    }
    void setStopPoint(const QPointF &p) {
        m_stopPoint = p;
        updateGeometry();
    }

protected:
    void updateGeometry();

protected:

    QPointF m_startPoint;
    QPointF m_stopPoint;
};

#endif // CURVEITEM_H
