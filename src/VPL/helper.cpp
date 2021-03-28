#include "helper.h"
#include <QtMath>

const QPointF bezierCurve(const QPointF &p0, const QPointF &p1, const QPointF &p2, const QPointF &p3, qreal t) {
    const QPointF p = qPow(1-t,3) * p0 + 3*t*qPow(1-t,2) * p1 + 3*(1-t)*qPow(t, 2) * p2 + qPow(t,3) * p3;
    return p;
}
