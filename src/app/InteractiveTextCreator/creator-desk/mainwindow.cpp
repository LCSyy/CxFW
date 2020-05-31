#include "mainwindow.h"
#include <QSplitter>
#include <QToolBar>
#include <QTextEdit>
#include <QPushButton>
#include <QVBoxLayout>
#include <QGraphicsView>
#include <QGraphicsScene>
#include <QGraphicsRectItem>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    initUi();
}

MainWindow::~MainWindow()
{
}

void MainWindow::initUi()
{
    QToolBar *toolBar = addToolBar(tr("TopToolBar"));
    toolBar->addAction(tr("File(&F)"));

    QSplitter *splitter = new QSplitter(this);
    splitter->setOrientation(Qt::Horizontal);
    setCentralWidget(splitter);

    QWidget *wgt = new QWidget(splitter);
    splitter->addWidget(wgt);
    initGraphicsView(wgt);

    QSplitter *vSplitter = new QSplitter(splitter);
    vSplitter->setOrientation(Qt::Vertical);
    splitter->addWidget(vSplitter);

    textEdit = new QTextEdit(splitter);
    vSplitter->addWidget(textEdit);

    QWidget *wgt2 = new QWidget(vSplitter);
    vSplitter->addWidget(wgt2);
}

void MainWindow::initGraphicsView(QWidget *parent)
{
    QVBoxLayout *vlayout = new QVBoxLayout(parent);
    vlayout->setMargin(0);
    vlayout->setSpacing(0);
    graphScene = new QGraphicsScene(this);
    graphView = new QGraphicsView(graphScene,parent);
    vlayout->addWidget(graphView);
}

