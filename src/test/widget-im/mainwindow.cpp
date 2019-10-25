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
#include <QUrl>
#include <QUrlQuery>
#include "chatwidget.h"
#include "navi/contactnavi.h"

#include <QDebug>

namespace cx_test {

    void initNavi(QStackedWidget *wgt) {
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

}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    mToolBar = new QToolBar(this);
    mToolBar->setMovable(false);
    mToolBar->setFloatable(false);
    addToolBar(Qt::LeftToolBarArea, mToolBar);

    mSplitter = new QSplitter(this);
    mSplitter->setOrientation(Qt::Horizontal);
    setCentralWidget(mSplitter);

    mNaviDock = new QStackedWidget(mSplitter);
    mNaviDock->setMinimumWidth(200);
    mNaviDock->setMaximumWidth(400);

    QWidget *chatWgt = new QWidget(mSplitter);
    QVBoxLayout *chatLayout = new QVBoxLayout(chatWgt);
    chatLayout->setMargin(0);
    chatLayout->setSpacing(0);

    mCurLabel = new QLabel(chatWgt);
    mCurLabel->setFixedHeight(50);
    mCurLabel->setText("Chating with LLy ...");
    mCurLabel->setAlignment(Qt::AlignCenter);
    chatLayout->addWidget(mCurLabel);

    mTabBar = new QTabBar(chatWgt);
    mTabBar->setExpanding(false);
    mTabBar->setStyleSheet("QTabBar::tab{min-width:150px;}");
    mTabBar->addTab(tr("Frd"));
    mTabBar->addTab(tr("Alli"));
    mTabBar->addTab(tr("Ckd"));
    chatLayout->addWidget(mTabBar);

    QStackedWidget *tabWgt = new QStackedWidget(chatWgt);
    chatLayout->addWidget(tabWgt,1);

    ChatWidget *chatPage = new ChatWidget(tabWgt);
    tabWgt->addWidget(chatPage);

    mSplitter->addWidget(mNaviDock);
    mSplitter->addWidget(chatWgt);
    mSplitter->setStretchFactor(1,1);

    ContactNavi *ccNavi = new ContactNavi(mNaviDock);
    addNavi(ccNavi,QUrl("navi/contact"));
    ContactNavi *cc2Navi = new ContactNavi(mNaviDock);
    addNavi(cc2Navi,QUrl("navi/contact2"));


    resize(900,540);
}

MainWindow::~MainWindow()
{
}

void MainWindow::addNavi(NaviWidget *navi, const QUrl &naviUrl)
{
    if(!navi) { return; }

    QAction *act = nullptr;
    if(navi->icon().isNull()) {
        act = new QAction(navi->icon(),navi->text(),mToolBar);
    } else {
        act = new QAction(navi->text(),mToolBar);
    }

    navi->setProperty("url",QVariant::fromValue(naviUrl));
    act->setProperty("url",QVariant::fromValue(naviUrl));
    act->setCheckable(true);
    mToolBar->addAction(act);
    mNaviDock->addWidget(navi);

    QObject::connect(act,SIGNAL(triggered(bool)),this,SLOT(onNaviActionTriggered(bool)));
}

void MainWindow::collapseNavi(bool collpase)
{
    int s = mSplitter->sizes().first();
    if(collpase) {
        if(s != 0) {
            mSplitter->setSizes({0,mSplitter->width()});
        }
    } else {
        mSplitter->setSizes({200,mSplitter->width() - 200});
    }
}

/*!
 * \brief MainWindow::openTabPage
 * \param tabPageUrl
 * {path}?{query=value}
 * path: chat | news | group | ...
 */
void MainWindow::openPage(const QUrl &tabPageUrl)
{
    bool found {false};
    for(int i = 0; i < mTabBar->count(); ++i) {
        const QVariantMap tabMap = mTabBar->tabData(i).toMap();
        const QUrl tabUrl = tabMap.value("url").toUrl();
        if(tabUrl == tabPageUrl) {
            found = true;
            mTabBar->setCurrentIndex(i);
            break;
        }
    }

    if(!found) { // create tab widget

    }
}

void MainWindow::onNaviActionTriggered(bool checked)
{
    QAction *act = qobject_cast<QAction*>(sender());
    if(act) {
        const QUrl naviUrl = act->property("url").toUrl();
        if(checked) {
            for(QAction *a: mToolBar->actions()) {
                if(a->property("url").toUrl() != naviUrl) {
                    a->setChecked(false);
                }
            }
            for(int i = 0; i < mNaviDock->count(); ++i) {
                QWidget *wgt = mNaviDock->widget(i);
                if(wgt) {
                    if(wgt->property("url").toUrl() == naviUrl) {
                        mNaviDock->setCurrentIndex(i);
                        break;
                    }
                }
            }
            collapseNavi(false);
        } else {
            collapseNavi(true);
        }
    }
}

