#include "curveitem.h"
#include <QPainter>
#include <QPolygonF>
#include "helper.h"

CurveItem::CurveItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{

}

CurveItem::~CurveItem()
{

}

void CurveItem::paint(QPainter *p)
{
    p->setRenderHint(QPainter::Antialiasing, true);
    QPen pen;
    pen.setColor(Qt::black);
    pen.setWidth(2);
    p->setPen(pen);
    p->drawLine(m_startPoint - position(), m_stopPoint - position());
}

void CurveItem::updateGeometry()
{
    const QPointF d = m_stopPoint - m_startPoint;
    qreal x = m_startPoint.x();
    qreal y = m_startPoint.y();
    const qreal w = qAbs(d.x());
    const qreal h = qAbs(d.y());

    if (d.x() < 0) {
        x = m_stopPoint.x();
    }

    if (d.y() < 0) {
        y = m_stopPoint.y();
    }

    setX(x-4.0);
    setY(y-4.0);
    setWidth(w+8.0);
    setHeight(h+8.0);

    update();
}
