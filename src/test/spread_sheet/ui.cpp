#include "ui.h"
#include <QVBoxLayout>
#include <QTableView>
#include "mainwindow.h"

namespace widget_ui {

void Ui::setupUi(MainWindow *wgt) {
    QWidget *central = new QWidget(wgt);
    wgt->setCentralWidget(central);

    QVBoxLayout *vlayout = new QVBoxLayout(central);
    vlayout->setMargin(0);
    vlayout->setSpacing(0);

    mTableView = new QTableView(central);
    vlayout->addWidget(mTableView);
}

}
