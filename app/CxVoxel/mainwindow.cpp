#include "mainwindow.h"
#include <QRandomGenerator>
#include <Qt3DExtras/Qt3DWindow>
#include <Qt3DCore/QEntity>
#include <Qt3DCore/QTransform>
#include <Qt3DRender/QCamera>
#include <Qt3DRender/QCameraLens>
#include <Qt3DRender/QObjectPicker>
#include <Qt3DRender/QPickEvent>
#include <Qt3DRender/QGeometry>
#include <Qt3DRender/QRenderSettings>
#include <Qt3DRender/QAttribute>
#include <Qt3DExtras/QForwardRenderer>
#include <Qt3DExtras/QCuboidMesh>
#include <Qt3DExtras/QPhongMaterial>

#include "cameracontroller.h"

#include <QDebug>

using namespace Qt3DCore;
using namespace Qt3DRender;
using namespace Qt3DExtras;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , m_view(new Qt3DExtras::Qt3DWindow())
{
    QWidget *view = QWidget::createWindowContainer(m_view);
    setCentralWidget(view);
    resize(800,600);

    init3DScene();

    m_view->show();
}

MainWindow::~MainWindow()
{
}

Qt3DCore::QEntity *MainWindow::addCube(Qt3DCore::QEntity *parent)
{
    QEntity *cube = new QEntity(parent);

    Qt3DCore::QTransform *trans = new Qt3DCore::QTransform(cube);

    auto rand = QRandomGenerator::system();
    float width = 500;
    trans->setTranslation(QVector3D(
                              rand->generateDouble()*width,
                              rand->generateDouble()*width,
                              rand->generateDouble()*width)
                          );


//    QObjectPicker *picker = new QObjectPicker(cube);
//    picker->setHoverEnabled(false);
//    picker->setEnabled(true);
//    connect(picker,&QObjectPicker::pressed, [](QPickEvent *ev){
//        qDebug() << "Hey";
//        if (ev->entity()) {
//            qDebug() << "entity:" << ev->entity()->id();
//        }
//    });

//    cube->addComponent(picker);
    cube->addComponent(trans);

    return cube;
}

void MainWindow::init3DScene()
{
    m_root = new QEntity;
    m_view->setRootEntity(m_root);

//    Qt3DRender::QRenderSettings *mRenderSettings = new Qt3DRender::QRenderSettings();
//    mRenderSettings->pickingSettings()->setPickMethod(Qt3DRender::QPickingSettings::TrianglePicking);
//    mRenderSettings->pickingSettings()->setPickResultMode(Qt3DRender::QPickingSettings::NearestPick);
//    mRenderSettings->setActiveFrameGraph(m_view->defaultFrameGraph());
//    m_root->addComponent(mRenderSettings);

    Qt3DRender::QCamera *camera = m_view->camera();
    camera->lens()->setPerspectiveProjection(45.0f, 16.0f/9.0f, 0.1f, 1000.0f);
    camera->setPosition(QVector3D(0, 0, 0));
    camera->setViewCenter(QVector3D(1, 1, 1));

    CameraController *camController = new CameraController(m_root);
    camController->setCamera(camera);
    camController->setAcceleration(50.0f);
    camController->setDeceleration(50.0f);
    camController->setVelocity(50.0f,80.0f,50.0f);


    Qt3DRender::QMaterial *material = new Qt3DExtras::QPhongMaterial(m_root);
    Qt3DExtras::QCuboidMesh *mesh = new Qt3DExtras::QCuboidMesh(m_root);
    mesh->setXExtent(1);
    mesh->setYExtent(1);
    mesh->setZExtent(1);

    QGeometry *geo = mesh->geometry();
    if (geo) {
        qDebug() << "default:" << QAttribute::defaultPositionAttributeName();

        QAttribute *bv = geo->boundingVolumePositionAttribute();
        if (bv) {
            qDebug() << "-->name:" << bv->name();
            qDebug() << "-->count:" << bv->count();
        }
        for (auto attr: geo->attributes()) {
            if (attr) {
                qDebug() << "name:" << attr->name();
                qDebug() << "count:" << attr->count();
            }
        }
    }

    int counts = 100;
    while (counts >= 0) {
        --counts;
        Qt3DCore::QEntity *cube = addCube(m_root);
        cube->addComponent(material);
        cube->addComponent(mesh);
    }
}

