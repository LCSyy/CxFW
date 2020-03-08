#include "shapeitem.h"
#include <cstdlib>
#include <QSGGeometry>
#include <QSGGeometryNode>
#include <QSGFlatColorMaterial>

#include <QColor>
#include <QPointF>

ShapeItem::ShapeItem(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(QQuickItem::ItemHasContents);
}

void ShapeItem::setColor(const QColor &c)
{
    if (mColor != c) {
        mColor = c;
        emit colorChanged(mColor);
    }
}

const QColor &ShapeItem::color() const
{
    return mColor;
}

void ShapeItem::setVertices(const QVariantList &v)
{
    for (const QVariant &var: v) {
        QPointF p = var.toPointF();
        mVertices.append(p);
    }
}

QPointF ShapeItem::vertex(const int idx) const
{
    return mVertices.value(idx);
}

QSGNode *ShapeItem::updatePaintNode(QSGNode *oldNode,
                                    QQuickItem::UpdatePaintNodeData *updatePaintNodeData)
{
    Q_UNUSED(updatePaintNodeData)

    QSGGeometryNode *n = static_cast<QSGGeometryNode*>(oldNode);
    if (!n) {
        n = new QSGGeometryNode;
    }

    if (mVertices.size() > 0) {
        QSGGeometry *geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), mVertices.size());
        geometry->setDrawingMode(QSGGeometry::DrawTriangles);
        geometry->setVertexDataPattern(QSGGeometry::StaticPattern);

        for (int i = 0; i < mVertices.size(); ++i) {
            const QPointF &p = mVertices[i];
            geometry->vertexDataAsPoint2D()[i].set(static_cast<float>(p.x()),
                                                   static_cast<float>(p.y()));
        }
        n->setGeometry(geometry);
        n->setFlag(QSGNode::OwnsGeometry);
    }

    if (mColor.isValid()) {
        QSGFlatColorMaterial *material = new QSGFlatColorMaterial;
        material->setColor(mColor);
        n->setMaterial(material);
        n->setFlag(QSGNode::OwnsMaterial);
    }

    n->markDirty(QSGGeometryNode::DirtyGeometry | QSGGeometryNode::DirtyMaterial);

    return n;
}
