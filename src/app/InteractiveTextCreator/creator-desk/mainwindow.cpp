#include "mainwindow.h"
#include <QSplitter>
#include <QToolBar>
#include <QTextEdit>
#include <QPushButton>

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

    textEdit = new QTextEdit(splitter);
    splitter->addWidget(textEdit);
}

