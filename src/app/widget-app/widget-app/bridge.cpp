#include "bridge.h"
#include "mainwindow.h"
#include <QToolBar>
#include <QStackedWidget>
#include <QTabWidget>
#include <QQuickWidget>
#include <QUrl>

#include "module/colortoolwidget.h"
#include "module/userlistwidget.h"
#include "module/chatwidget.h"

namespace {

void meInfo() {
    const QUrl url{"app:/page/chat"};
    QQuickWidget *chatView = qobject_cast<QQuickWidget*>(MainWindow::self()->findPage(url));
    if(!chatView) {
        chatView = new QQuickWidget(MainWindow::self()->tabWidget());
        chatView->setProperty("url",url);
        chatView->setResizeMode(QQuickWidget::SizeRootObjectToView);
        chatView->setSource(QUrl("qrc:/qml/ChatView.qml"));
        MainWindow::self()->addPage(chatView);
    } else {
        MainWindow::self()->setPage(url);
    }
}

void userList() {
    const QUrl url{"app:/page/users"};
    QWidget *userList = MainWindow::self()->findNavi(url);
    if(!userList) {
        userList = new UserListWidget(MainWindow::self()->tabWidget());
        userList->setProperty("url",url);
        MainWindow::self()->addNavi(userList);
    } else {
        MainWindow::self()->setNavi(url);
    }
    MainWindow::self()->expandNavi();
}

void setNavi() {
    const QUrl url{"app:/navi/settings"};
    QWidget *navi = MainWindow::self()->findNavi(url);
    if(!navi) {
        navi = new QWidget(MainWindow::self()->stackedWidget());
        navi->setProperty("url", url);
        navi->setStyleSheet("background-color:#AB56AA");
        MainWindow::self()->addNavi(navi);
    } else {
        MainWindow::self()->setNavi(url);
    }
    MainWindow::self()->expandNavi();
}

void colorPage() {
    const QUrl url{"app:/navi/color"};
    ColorToolWidget *navi = qobject_cast<ColorToolWidget*>(MainWindow::self()->findNavi(url));
    if(!navi) {
        navi = new ColorToolWidget(MainWindow::self()->stackedWidget());
        navi->setProperty("url", url);
        MainWindow::self()->addNavi(navi);
    } else {
        MainWindow::self()->setNavi(url);
    }
    MainWindow::self()->expandNavi();
}

void quickPage() {
    const QUrl url{"app:/page/quick"};
    QQuickWidget *quickView = qobject_cast<QQuickWidget*>(MainWindow::self()->findPage(url));
    if(!quickView) {
        quickView = new QQuickWidget(MainWindow::self()->tabWidget());
        quickView->setProperty("url",url);
        quickView->setResizeMode(QQuickWidget::SizeRootObjectToView);
        quickView->setSource(QUrl("qrc:/qml/Draft.qml"));
        MainWindow::self()->addPage(quickView);
    } else {
        MainWindow::self()->setPage(url);
    }
}

}

void Bridge::initToolBar()
{
    QToolBar *toolBar = MainWindow::self()->toolBar();

    // me
    QAction *me = new QAction(QObject::tr("M"),toolBar);
    me->setToolTip(QObject::tr("Instant Message"));
    me->setProperty("url",QUrl("app:/toolbar/action/user"));
    QObject::connect(me,&QAction::triggered,meInfo);
    toolBar->addAction(me);
    toolBar->addSeparator();

    // user list
    QAction *users = new QAction(QObject::tr("U"),toolBar);
    users->setToolTip(QObject::tr("User List"));
    users->setProperty("url",QUrl("app:/toolbar/action/user"));
    QObject::connect(users,&QAction::triggered,userList);
    toolBar->addAction(users);

    // color tool
    QAction * color = new QAction(QObject::tr("C"),toolBar);
    color->setToolTip(QObject::tr("Color Tool"));
    color->setProperty("url",QUrl("app:/toolbar/action/color"));
    QObject::connect(color,&QAction::triggered,colorPage);
    toolBar->addAction(color);

    // quick ui
    QAction *quick = new QAction(QObject::tr("Q"),toolBar);
    quick->setProperty("url",QUrl("app:/toolbar/action/quick"));
    QObject::connect(quick,&QAction::triggered,quickPage);
    toolBar->addAction(quick);

    // settings
    toolBar->addSeparator();
    QAction *act = new QAction(QObject::tr("S"),toolBar);
    act->setProperty("url",QUrl("app:/toolbar/action/settings"));
    QObject::connect(act, &QAction::triggered, setNavi);
    toolBar->addAction(act);
}

void Bridge::startSetting()
{
    MainWindow::self()->resize(850,550);
    MainWindow::self()->expandNavi(false);
}
