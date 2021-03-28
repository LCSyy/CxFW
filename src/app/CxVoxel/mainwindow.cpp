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
#include <Qt3DExtras/QTorusMesh>

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

    Qt3DExtras::QCuboidMesh *mesh = new Qt3DExtras::QCuboidMesh(cube);
    mesh->setXExtent(10);
    mesh->setYExtent(10);
    mesh->setZExtent(10);

    Qt3DRender::QMaterial *material = new Qt3DExtras::QPhongMaterial(cube);
    Qt3DCore::QTransform *trans = new Qt3DCore::QTransform(cube);

    auto rand = QRandomGenerator::system();
    float width = 500;
    trans->setTranslation(QVector3D(
                              rand->generateDouble()*width,
                              rand->generateDouble()*width,
                              rand->generateDouble()*width)
                          );

    QObjectPicker *picker = new QObjectPicker(cube);
    picker->setHoverEnabled(false);
    picker->setDragEnabled(false);
    connect(picker,SIGNAL(pressed(Qt3DRender::QPickEvent*)),this,SLOT(onPick(Qt3DRender::QPickEvent*)));

    cube->addComponent(picker);
    cube->addComponent(trans);
    cube->addComponent(mesh);
    cube->addComponent(material);

    return cube;
}

void MainWindow::onPick(Qt3DRender::QPickEvent *ev)
{
    QEntity *entity = ev->entity();
    if (entity) {
        QVector<QPhongMaterial*> coms = entity->componentsOfType<QPhongMaterial>();
        // ...
    }
}

void MainWindow::init3DScene()
{
    m_root = new QEntity;
    m_view->setRootEntity(m_root);

    Qt3DRender::QCamera *camera = m_view->camera();
    camera->lens()->setPerspectiveProjection(45.0f, m_view->width()/m_view->height(), 0.1f, 1000.0f);
    camera->setPosition(QVector3D(0, 0, 0));
    camera->setViewCenter(QVector3D(1, 1, 1));

    CameraController *camController = new CameraController(m_root);
    camController->setCamera(camera);
    camController->setAcceleration(50.0f);
    camController->setDeceleration(50.0f);
    camController->setVelocity(50.0f,80.0f,50.0f);

    int counts = 100;
    while (counts-- >= 0) {
        addCube(m_root);
    }

    QEntity *torus = new QEntity(m_root);

    QTorusMesh *torusMesh = new QTorusMesh(torus);
    torusMesh->setRadius(50);
    torusMesh->setMinorRadius(20);
    torusMesh->setRings(10);
    torusMesh->setSlices(20);

    Qt3DRender::QMaterial *material = new Qt3DExtras::QPhongMaterial(torus);
    Qt3DCore::QTransform *transform = new Qt3DCore::QTransform(torus);

    QObjectPicker *picker2 = new QObjectPicker(torus);
    picker2->setHoverEnabled(false);
    picker2->setDragEnabled(false);
    connect(picker2,SIGNAL(pressed(Qt3DRender::QPickEvent*)),this,SLOT(onPick(Qt3DRender::QPickEvent*)));

    torus->addComponent(torusMesh);
    torus->addComponent(transform);
    torus->addComponent(material);
    torus->addComponent(picker2);
}

