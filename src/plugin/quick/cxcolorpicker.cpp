#include "cxcolorpicker.h"
#include <QMouseEvent>
#include <QSGGeometry>
#include <QSGGeometryNode>
#include <QQuickWindow>
#include <QSGVertexColorMaterial>

struct Vertex {
    GLfloat x;
    GLfloat y;
    GLfloat r;
    GLfloat g;
    GLfloat b;
    GLfloat a;

    void set(GLfloat _x, GLfloat _y, GLfloat _r, GLfloat _g, GLfloat _b, GLfloat _a) {
        x = _x; y = _y; r = _r; g = _g; b = _b; a = _a;
    }
};

class CxColorPickerPrivate
{
public:
    CxColorPickerPrivate() {}
    ~CxColorPickerPrivate() {}

    // ...

    bool changeFlag{false};

private:
    Q_DISABLE_COPY(CxColorPickerPrivate)
};

CxColorPicker::CxColorPicker(QQuickItem *parent)
    : QQuickItem(parent)
    , d(new CxColorPickerPrivate)
{
    setFlag(QQuickItem::ItemHasContents);
}

CxColorPicker::~CxColorPicker()
{
    if(d)
        delete d;
}

QSGNode *CxColorPicker::updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *data)
{
    Q_UNUSED(data)

    QSGGeometryNode *geoNode = static_cast<QSGGeometryNode*>(oldNode);
    if(!geoNode) {
        geoNode = new QSGGeometryNode;

        static QSGGeometry::Attribute attributes[2] = {
            QSGGeometry::Attribute::create(0,2,GL_FLOAT,true),
            QSGGeometry::Attribute::create(1,4,GL_FLOAT,false)
        };

        static QSGGeometry::AttributeSet sets = {
            2,
            sizeof(Vertex),
            attributes
        };

        int vertexCount = 14;
        int indexCount = 36;
        QSGGeometry *geo = new QSGGeometry(sets,vertexCount,indexCount);
        geo->setDrawingMode(GL_TRIANGLES);

        geo->allocate(vertexCount,indexCount);

        float unitW = static_cast<float>(width()) / 6.0f;
        float unitH = static_cast<float>(height());

        Vertex *vertex = static_cast<Vertex*>(geo->vertexData());
        if(vertex) {
            ushort curIndex = 0;
            vertex[curIndex++].set( 0.0f, 0.0f,1.0f,0.0f,0.0f,1.0f); // 0
            vertex[curIndex++].set(unitW, 0.0f,1.0f,1.0f,0.0f,1.0f); // 1
            vertex[curIndex++].set( 0.0f,unitH,1.0f,0.0f,0.0f,1.0f); // 2
            vertex[curIndex++].set(unitW,unitH,1.0f,1.0f,0.0f,1.0f); // 3

            vertex[curIndex++].set(unitW*2, 0.0f,0.0f,1.0f,0.0f,1.0f); // 4
            vertex[curIndex++].set(unitW*2,unitH,0.0f,1.0f,0.0f,1.0f); // 5
            vertex[curIndex++].set(unitW*3, 0.0f,0.0f,1.0f,1.0f,1.0f); // 6
            vertex[curIndex++].set(unitW*3,unitH,0.0f,1.0f,1.0f,1.0f); // 7

            vertex[curIndex++].set(unitW*4, 0.0f,0.0f,0.0f,1.0f,1.0f); // 8
            vertex[curIndex++].set(unitW*4,unitH,0.0f,0.0f,1.0f,1.0f); // 9
            vertex[curIndex++].set(unitW*5, 0.0f,1.0f,0.0f,1.0f,1.0f); // 10
            vertex[curIndex++].set(unitW*5,unitH,1.0f,0.0f,1.0f,1.0f); // 11

            vertex[curIndex++].set(unitW*6, 0.0f,1.0f,0.0f,0.0f,1.0f); // 12
            vertex[curIndex++].set(unitW*6,unitH,1.0f,0.0f,0.0f,1.0f); // 13
        }

        ushort *index  = static_cast<ushort*>(geo->indexData());
        if(index) {
            ushort curIndex = 0;
            index[curIndex++] = 0; index[curIndex++] = 1; index[curIndex++] = 2;
            index[curIndex++] = 2; index[curIndex++] = 1; index[curIndex++] = 3;

            index[curIndex++] = 1; index[curIndex++] = 4; index[curIndex++] = 3;
            index[curIndex++] = 3; index[curIndex++] = 4; index[curIndex++] = 5;

            index[curIndex++] = 4; index[curIndex++] = 6; index[curIndex++] = 5;
            index[curIndex++] = 5; index[curIndex++] = 6; index[curIndex++] = 7;

            index[curIndex++] = 6; index[curIndex++] = 8; index[curIndex++] = 7;
            index[curIndex++] = 7; index[curIndex++] = 8; index[curIndex++] = 9;

            index[curIndex++] = 8; index[curIndex++] = 10; index[curIndex++] = 9;
            index[curIndex++] = 9; index[curIndex++] = 10; index[curIndex++] = 11;

            index[curIndex++] = 10; index[curIndex++] = 12; index[curIndex++] = 11;
            index[curIndex++] = 11; index[curIndex++] = 12; index[curIndex++] = 13;
        }

        geoNode->setGeometry(geo);
        geoNode->setFlag(QSGNode::OwnsGeometry);
        geoNode->setMaterial(new QSGVertexColorMaterial);
        geoNode->setFlag(QSGNode::OwnsMaterial);
        geoNode->setFlag(QSGNode::OwnedByParent);
        geoNode->markDirty(QSGNode::DirtyGeometry);
        geoNode->markDirty(QSGNode::DirtyMaterial);

        d->changeFlag = true;
    } else {
        QSGGeometry *geo = geoNode->geometry();
        int vertexCount = 14;
        int indexCount = 36;
        if(geo) {
            geo->allocate(vertexCount,indexCount);

            float unitW = static_cast<float>(width()) / 6.0f;
            float unitH = static_cast<float>(height());

            Vertex *vertex = static_cast<Vertex*>(geo->vertexData());
            if(vertex) {
                ushort curIndex = 0;
                vertex[curIndex++].set( 0.0f, 0.0f,1.0f,0.0f,0.0f,1.0f); // 0
                vertex[curIndex++].set(unitW, 0.0f,1.0f,1.0f,0.0f,1.0f); // 1
                vertex[curIndex++].set( 0.0f,unitH,1.0f,0.0f,0.0f,1.0f); // 2
                vertex[curIndex++].set(unitW,unitH,1.0f,1.0f,0.0f,1.0f); // 3

                vertex[curIndex++].set(unitW*2, 0.0f,0.0f,1.0f,0.0f,1.0f); // 4
                vertex[curIndex++].set(unitW*2,unitH,0.0f,1.0f,0.0f,1.0f); // 5
                vertex[curIndex++].set(unitW*3, 0.0f,0.0f,1.0f,1.0f,1.0f); // 6
                vertex[curIndex++].set(unitW*3,unitH,0.0f,1.0f,1.0f,1.0f); // 7

                vertex[curIndex++].set(unitW*4, 0.0f,0.0f,0.0f,1.0f,1.0f); // 8
                vertex[curIndex++].set(unitW*4,unitH,0.0f,0.0f,1.0f,1.0f); // 9
                vertex[curIndex++].set(unitW*5, 0.0f,1.0f,0.0f,1.0f,1.0f); // 10
                vertex[curIndex++].set(unitW*5,unitH,1.0f,0.0f,1.0f,1.0f); // 11

                vertex[curIndex++].set(unitW*6, 0.0f,1.0f,0.0f,0.0f,1.0f); // 12
                vertex[curIndex++].set(unitW*6,unitH,1.0f,0.0f,0.0f,1.0f); // 13
            }

            ushort *index  = static_cast<ushort*>(geo->indexData());
            if(index) {
                ushort curIndex = 0;
                index[curIndex++] = 0; index[curIndex++] = 1; index[curIndex++] = 2;
                index[curIndex++] = 2; index[curIndex++] = 1; index[curIndex++] = 3;

                index[curIndex++] = 1; index[curIndex++] = 4; index[curIndex++] = 3;
                index[curIndex++] = 3; index[curIndex++] = 4; index[curIndex++] = 5;

                index[curIndex++] = 4; index[curIndex++] = 6; index[curIndex++] = 5;
                index[curIndex++] = 5; index[curIndex++] = 6; index[curIndex++] = 7;

                index[curIndex++] = 6; index[curIndex++] = 8; index[curIndex++] = 7;
                index[curIndex++] = 7; index[curIndex++] = 8; index[curIndex++] = 9;

                index[curIndex++] = 8; index[curIndex++] = 10; index[curIndex++] = 9;
                index[curIndex++] = 9; index[curIndex++] = 10; index[curIndex++] = 11;

                index[curIndex++] = 10; index[curIndex++] = 12; index[curIndex++] = 11;
                index[curIndex++] = 11; index[curIndex++] = 12; index[curIndex++] = 13;
            }
            geoNode->markDirty(QSGNode::DirtyGeometry);

            d->changeFlag = true;
        }
    }

    return geoNode;
}

