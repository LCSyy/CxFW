#include "canvas_line.h"
#include <QSGGeometry>
#include <QSGFlatColorMaterial>
#include <QSGGeometryNode>

CanvasLine::CanvasLine(QQuickItem *parent)
    : QQuickItem(parent)
{
    setFlag(QQuickItem::ItemHasContents,true);
}

CanvasLine::~CanvasLine()
{

}

QSGNode *CanvasLine::updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *updatePaintNodeData)
{
    QSGGeometryNode *n = static_cast<QSGGeometryNode*>(oldNode);
    if (!n) {
        n = new QSGGeometryNode;

        QSGGeometry *geometry = new QSGGeometry(QSGGeometry::defaultAttributes_Point2D(), 2);
        geometry->setDrawingMode(GL_LINES);
        geometry->setLineWidth(3);
        geometry->vertexDataAsPoint2D()[0].set(0, 0);
        geometry->vertexDataAsPoint2D()[1].set(width(), height());

        QSGFlatColorMaterial *material = new QSGFlatColorMaterial;
        material->setColor(QColor(255, 0, 0));
        n->setGeometry(geometry);
        n->setFlag(QSGNode::OwnsGeometry);
        n->setMaterial(material);
        n->setFlag(QSGNode::OwnsMaterial);
    }

    n->markDirty(QSGNode::DirtyGeometry | QSGNode::DirtyMaterial | QSGNode::DirtyMatrix);
    return n;
}

