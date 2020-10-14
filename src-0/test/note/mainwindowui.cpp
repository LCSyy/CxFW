#include "mainwindowui.h"
#include "mainwindow.h"
#include <QVBoxLayout>
#include <QLineEdit>
#include <QFont>
#include <Qurl>
#include <QApplication>
#include <QQuickWidget>

void MainWindowUi::setupUi(MainWindow *wgt)
{
    QWidget *central = new QWidget(wgt);
    wgt->setCentralWidget(central);

    QVBoxLayout *vlayout = new QVBoxLayout(central);
    vlayout->setMargin(0);
    vlayout->setSpacing(3);

    mInputField = new QLineEdit(central);
    vlayout->addWidget(mInputField);

    QFont font = qApp->font();
    font.setBold(true);
    mInputField->setFont(font);

    mQuickView = new QQuickWidget(central);
    mQuickView->setResizeMode(QQuickWidget::SizeRootObjectToView);
    mQuickView->setSource(QUrl("qrc:/main.qml"));
    vlayout->addWidget(mQuickView,1);
}
