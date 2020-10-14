#include "mainwindow.h"
#include "ui.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new widget_ui::Ui)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    if (ui) {
        delete ui;
    }
}

