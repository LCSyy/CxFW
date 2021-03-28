#include "edgeitem.h"
#include <QSGGeometryNode>
#include <QSGGeometry>
#include <QSGFlatColorMaterial>
#include "helper.h"

EdgeItem::EdgeItem(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);
}

EdgeItem::~EdgeItem()
{

}

QSGNode *EdgeItem::updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *data)
{
    Q_UNUSED(data)

    QSGGeometry *geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), 2);
    geometry->setDrawingMode(GL_LINES);
    geometry->setLineWidth(3);

    const QPointF p1 = m_startPoint - position();
    const QPointF p2 = m_stopPoint - position();
    geometry->vertexDataAsPoint2D()[0].set(p1.x(), p1.y());
    geometry->vertexDataAsPoint2D()[1].set(p2.x(), p2.y());

    QSGFlatColorMaterial *material = new QSGFlatColorMaterial;
    material->setColor(m_color);

    QSGGeometryNode *node = dynamic_cast<QSGGeometryNode*>(oldNode);
    if (!node) {
        node = new QSGGeometryNode;
    }
    node->setGeometry(geometry);
    node->setFlag(QSGNode::OwnsGeometry);
    node->setMaterial(material);
    node->setFlag(QSGNode::OwnsMaterial);

    node->markDirty(QSGNode::DirtyGeometry | QSGNode::DirtyMaterial);

    return node;
}

void EdgeItem::updateGeometry()
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
