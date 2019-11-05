#include "bridge.h"
#include "mainwindow.h"
#include <QToolBar>
#include <QStackedWidget>
#include <QTabWidget>
#include <QUrl>

namespace {

void userPage() {
    const QUrl url{"app:/page/user"};
    QWidget *userPage = MainWindow::self()->findPage(url);
    if(!userPage) {
        userPage = new QWidget(MainWindow::self()->tabWidget());
        userPage->setProperty("url",url);
        userPage->setStyleSheet("background-color:#731946");
        MainWindow::self()->addPage(userPage);
    }
}

void setNavi() {
    const QUrl url{"app:/navi/settings"};
    QWidget *navi = MainWindow::self()->findNavi(url);
    if(!navi) {
        navi = new QWidget(MainWindow::self()->stackedWidget());
        navi->setProperty("url", url);
        navi->setStyleSheet("background-color:#AB56AA");
        MainWindow::self()->addNavi(navi);
    }
    MainWindow::self()->expandNavi();
}

}

void Bridge::initToolBar()
{
    QToolBar *toolBar = MainWindow::self()->toolBar();

    QAction *user = new QAction(QObject::tr("U"),toolBar);
    user->setProperty("url",QUrl("app://toolbar/action/user"));
    QObject::connect(user,&QAction::triggered,userPage);
    toolBar->addAction(user);

    // settings
    QAction *act = new QAction(QObject::tr("S"),toolBar);
    act->setProperty("url",QUrl("app://toolbar/action/settings"));
    QObject::connect(act, &QAction::triggered, setNavi);
    toolBar->addAction(act);
}

void Bridge::startSetting()
{
    MainWindow::self()->resize(850,550);
    MainWindow::self()->expandNavi(false);
}
