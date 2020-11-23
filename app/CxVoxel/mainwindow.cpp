#include "mainwindow.h"
#include <Qt3DExtras/Qt3DWindow>
#include <Qt3DCore/QEntity>
#include <Qt3DCore/QTransform>
#include <Qt3DExtras/QCuboidMesh>
#include <Qt3DExtras/QPhongMaterial>

using namespace Qt3DCore;
using namespace Qt3DExtras;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , m_view(new Qt3DExtras::Qt3DWindow())
{
    QWidget *view = QWidget::createWindowContainer(m_view);
    setCentralWidget(view);

    init3DScene();
}

MainWindow::~MainWindow()
{
}

void MainWindow::addCube()
{
    QEntity *cube = new QEntity(m_root);

    Qt3DCore::QTransform *transform = new Qt3DCore::QTransform(cube);
    QPhongMaterial *material = new QPhongMaterial(cube);

    QCuboidMesh *mesh = new QCuboidMesh(cube);
    mesh->setXExtent(1);
    mesh->setYExtent(1);
    mesh->setZExtent(1);

    cube->addComponent(transform);
    cube->addComponent(material);
    cube->addComponent(mesh);
}

void MainWindow::init3DScene()
{
    using namespace Qt3DCore;
    using namespace Qt3DExtras;

    m_root = new QEntity;
    m_view->setRootEntity(m_root);

}

