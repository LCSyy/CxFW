#include "mainwindow.h"
#include "mainwindowui.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new MainWindowUi)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    if (ui) { delete ui; }
}

