#include "mainwindow.h"
#include <QToolBar>
#include <QSplitter>
#include <QSizePolicy>
#include <QPixmap>
#include <QLabel>
#include <QTabBar>
#include <QPushButton>
#include <QListWidget>
#include <QTabWidget>
#include <QActionGroup>
#include <QVBoxLayout>
#include <QStackedWidget>
#include "chatwidget.h"

namespace  {
    void initToolBar(MainWindow *window, QToolBar *toolbar) {
        QAction *userAct = new QAction(QIcon(":/ArrowOnly32x.png"),"User Home",toolbar);
        QAction *historyAct = new QAction("His",toolbar);
        QAction *contactAct = new QAction("CC",toolbar);
        QAction *thirdAct = new QAction("Hhi",toolbar);

        userAct->setObjectName("USER_HOME");
        historyAct->setCheckable(true);
        historyAct->setObjectName("HISTORY");
        contactAct->setCheckable(true);
        contactAct->setObjectName("CONTACT");
        thirdAct->setCheckable(true);
        thirdAct->setObjectName("THIRD");

        toolbar->addAction(userAct);
        toolbar->addAction(historyAct);
        toolbar->addAction(contactAct);
        toolbar->addAction(thirdAct);

    }
}

namespace cx_test {

    void initStackedWgt(QStackedWidget *wgt) {
        QWidget *userInfoWgt = new QWidget(wgt);
        userInfoWgt->setStyleSheet("background:#123456");
        wgt->addWidget(userInfoWgt);
        QVBoxLayout *userInfoLayout = new QVBoxLayout(userInfoWgt);
        userInfoLayout->setMargin(0);
        userInfoLayout->setSpacing(0);
        QLabel *logo = new QLabel(userInfoWgt);
        logo->setPixmap(QPixmap(":/ArrowOnly.png"));
        userInfoLayout->addWidget(logo,0,Qt::AlignHCenter);
        userInfoLayout->addStretch(1);

        QWidget *ccWgt = new QWidget(wgt);
        wgt->addWidget(ccWgt);
        QVBoxLayout *ccLayout = new QVBoxLayout(ccWgt);
        ccLayout->setMargin(0);
        ccLayout->setSpacing(0);

        QListWidget *lstWgt = new QListWidget(ccWgt);
        lstWgt->addItem("Bb");
        lstWgt->addItem("Uyho");
        lstWgt->addItem("lly");
        ccLayout->addWidget(lstWgt,1);

        QWidget *friWgt = new QWidget(wgt);
        friWgt->setStyleSheet("background:#789ABC");
        wgt->addWidget(friWgt);

        QWidget *stWgt = new QWidget(wgt);
        stWgt->setStyleSheet("background:#CBA987");
        wgt->addWidget(stWgt);
    }

    void initTabWgt(QTabWidget *wgt) {
        QWidget *chatWgt = new QWidget(wgt);
        wgt->addTab(chatWgt,"Bb");

        QWidget *chat2Wgt = new QWidget(wgt);
        wgt->addTab(chat2Wgt,"lly");
    }
}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    QToolBar *toolBar = new QToolBar(this);
    toolBar->setMovable(false);
    toolBar->setFloatable(false);
    ::initToolBar(this, toolBar);
    addToolBar(Qt::LeftToolBarArea, toolBar);

    QSplitter *splitter = new QSplitter(this);
    splitter->setOrientation(Qt::Horizontal);
    setCentralWidget(splitter);

    mPage = new QStackedWidget(splitter);
    mPage->setMinimumWidth(200);
    mPage->setMaximumWidth(400);
    cx_test::initStackedWgt(mPage);

    QWidget *chatWgt = new QWidget(splitter);
    QVBoxLayout *chatLayout = new QVBoxLayout(chatWgt);
    chatLayout->setMargin(0);
    chatLayout->setSpacing(0);

    mCurLabel = new QLabel(chatWgt);
    mCurLabel->setFixedHeight(50);
    mCurLabel->setText("Chating with LLy ...");
    mCurLabel->setAlignment(Qt::AlignCenter);
    chatLayout->addWidget(mCurLabel);

    QTabBar *tabBar = new QTabBar(chatWgt);
    tabBar->setExpanding(false);
    tabBar->setStyleSheet("QTabBar::tab{min-width:150px;}");
    tabBar->addTab(tr("Frd"));
    tabBar->addTab(tr("Alli"));
    tabBar->addTab(tr("Ckd"));
    chatLayout->addWidget(tabBar);

    QStackedWidget *tabWgt = new QStackedWidget(chatWgt);
    chatLayout->addWidget(tabWgt,1);

    ChatWidget *chatPage = new ChatWidget(tabWgt);
    tabWgt->addWidget(chatPage);

    splitter->addWidget(mPage);
    splitter->addWidget(chatWgt);
    splitter->setStretchFactor(1,1);

    resize(900,540);
}

MainWindow::~MainWindow()
{
}

void MainWindow::setCurrentPage(int idx)
{
    if(idx < 0 || mPage->count() <= idx) { return; }
    mPage->setCurrentIndex(idx);
}

