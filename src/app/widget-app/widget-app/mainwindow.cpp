#include "mainwindow.h"
#include <QToolBar>
#include <QSplitter>
#include <QTabWidget>
#include <QStackedWidget>
#include <QUrl>
#include "bridge.h"

namespace { MainWindow *mainWindow {nullptr}; }

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    if(!mainWindow) { mainWindow = this; }

    mToolBar = new QToolBar(this);
    mToolBar->setAllowedAreas(Qt::RightToolBarArea);
    mToolBar->setFloatable(false);
    mToolBar->setMovable(false);
    mToolBar->toggleViewAction()->setVisible(false);
    addToolBar(Qt::RightToolBarArea, mToolBar);

    mSplitter = new QSplitter(this);
    mSplitter->setOrientation(Qt::Horizontal);
    setCentralWidget(mSplitter);

    mTabWgt = new QTabWidget(mSplitter);
    mSplitter->addWidget(mTabWgt);

    mStackedWgt = new QStackedWidget(mSplitter);
    mStackedWgt->setMaximumWidth(400);
    mStackedWgt->setMinimumWidth(200);
    mSplitter->addWidget(mStackedWgt);

    Bridge::initToolBar();
    Bridge::startSetting();
}

MainWindow::~MainWindow()
{
    mainWindow = nullptr;
}

MainWindow *MainWindow::self()
{
    return ::mainWindow;
}

QToolBar *MainWindow::toolBar() const
{
    return mToolBar;
}

QSplitter *MainWindow::splitter() const
{
    return mSplitter;
}

QTabWidget *MainWindow::tabWidget() const
{
    return mTabWgt;
}

QStackedWidget *MainWindow::stackedWidget() const
{
    return mStackedWgt;
}

QWidget *MainWindow::findNavi(const QUrl &url) const
{
    for(int i = 0; i < mStackedWgt->count(); ++i) {
        QWidget *wgt = mStackedWgt->widget(i);
        if(wgt) {
            const QUrl naviUrl = wgt->property("url").toUrl();
            if(naviUrl == url) {
                return wgt;
            }
        }
    }
    return nullptr;
}

void MainWindow::addNavi(QWidget *wgt)
{
    if(wgt) {
        const QUrl url = wgt->property("url").toUrl();
        if(!findNavi(url)) {
            mStackedWgt->addWidget(wgt);
        }
        setNavi(url);
    }
}

void MainWindow::setNavi(const QUrl &url)
{
    for(int i = 0; i < mStackedWgt->count(); ++i) {
        QWidget *wgt = mStackedWgt->widget(i);
        if(wgt) {
            const QUrl naviUrl = wgt->property("url").toUrl();
            if(naviUrl == url) {
                mStackedWgt->setCurrentIndex(i);
                break;
            }
        }
    }
}

void MainWindow::expandNavi(bool expand)
{
    int s = mSplitter->sizes()[1];
    int minWidth = mStackedWgt->minimumWidth();
    if(expand && s == 0) {
        mSplitter->setSizes({mSplitter->width() - minWidth,minWidth});
    } else {
        mSplitter->setSizes({mSplitter->width(), 0});
    }
}

bool MainWindow::naviExpanded() const
{
    return mSplitter->sizes()[1] > 0;
}

QWidget *MainWindow::findPage(const QUrl &url) const
{
    for(int i = 0; i < mTabWgt->count(); ++i) {
        QWidget *wgt = mTabWgt->widget(i);
        if(wgt) {
            const QUrl pageUrl = wgt->property("url").toUrl();
            if(pageUrl == url) {
                return wgt;
            }
        }
    }
    return nullptr;
}

void MainWindow::addPage(QWidget *wgt)
{
    if(wgt) {
        const QUrl url = wgt->property("url").toUrl();
        if(!findPage(url)) {
            mTabWgt->addTab(wgt,tr("User Page"));
        }
        setPage(url);
    }
}

void MainWindow::setPage(const QUrl &url)
{
    for(int i = 0; i < mTabWgt->count(); ++i) {
        QWidget *wgt = mTabWgt->widget(i);
        if(wgt) {
            const QUrl pageUrl = wgt->property("url").toUrl();
            if(pageUrl == url) {
                mTabWgt->setCurrentIndex(i);
                break;
            }
        }
    }
}

