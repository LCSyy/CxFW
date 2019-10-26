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
#include <QStatusBar>
#include <QActionGroup>
#include <QVBoxLayout>
#include <QStackedWidget>
#include <QUrl>
#include <QUrlQuery>
#include "pagecontainer.h"
#include "navi/contactnavi.h"
#include "page/chatpage.h"

#include <QDebug>

namespace cx_test {

    void initNavi(MainWindow *window, QStackedWidget *naviDock) {

        ContactNavi *ccNavi = new ContactNavi(naviDock);
        ccNavi->setIcon(QIcon(":/icon/comments.svg"));
        ccNavi->setText("Chat");
        window->addNavi(ccNavi,QUrl("navi/contact"));

        ContactNavi *cc2Navi = new ContactNavi(naviDock);
        cc2Navi->setIcon(QIcon(":/icon/user-friends.svg"));
        cc2Navi->setText("Friends");
        window->addNavi(cc2Navi,QUrl("navi/contact_list"));

        QObject::connect(ccNavi, SIGNAL(contactDoubleClicked(const QUrl&)),
                window, SLOT(openPage(const QUrl&)));
    }

}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    mToolBar = new QToolBar(this);
    mToolBar->setMovable(false);
    mToolBar->setFloatable(false);
    mToolBar->addAction(QIcon(":/icon/user-circle.svg"),"User");
    mToolBar->addSeparator();
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
    mCurLabel->setAlignment(Qt::AlignCenter);
    chatLayout->addWidget(mCurLabel);

    mPageContainer = new PageContainer(chatWgt);
    chatLayout->addWidget(mPageContainer);

    mSplitter->addWidget(mNaviDock);
    mSplitter->addWidget(chatWgt);
    mSplitter->setSizes({0,mSplitter->width()});
    mSplitter->setStretchFactor(1,1);

    mCustomSeperator = mToolBar->addSeparator();
    mToolBar->addAction(QIcon(":/icon/cog.svg"),"Settings");

    statusBar()->showMessage("Welcome to Arrow Chat!",1000 * 10);

    connect(mSplitter,SIGNAL(splitterMoved(int,int)),
            this,SLOT(onSplitterMoved(int,int)));
    connect(mPageContainer,SIGNAL(currentPageChanged(const QUrl&)),
            this,SLOT(onCurrentPageChanged(const QUrl&)));

    resize(900,540);

    cx_test::initNavi(this,mNaviDock);
}

MainWindow::~MainWindow()
{
}

void MainWindow::addNavi(NaviWidget *navi, const QUrl &naviUrl)
{
    if(!navi) { return; }

    QAction *act = nullptr;
    if(navi->icon().isNull()) {
        act = new QAction(navi->text(),mToolBar);
    } else {
        act = new QAction(navi->icon(),navi->text(),mToolBar);
    }

    navi->setProperty("url",QVariant::fromValue(naviUrl));
    act->setProperty("url",QVariant::fromValue(naviUrl));
    act->setCheckable(true);
    mToolBar->insertAction(mCustomSeperator,act);
    mNaviDock->addWidget(navi);

    QObject::connect(act,SIGNAL(triggered(bool)),this,SLOT(onNaviActionTriggered(bool)));
}

void MainWindow::removeNavi(const QUrl &naviUrl)
{
    Q_UNUSED(naviUrl)
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
void MainWindow::openPage(const QUrl &pageUrl)
{
    mPageContainer->openPage(pageUrl);
}

void MainWindow::onSplitterMoved(int pos, int idx)
{
    if(idx == 1) {
        const QUrl url = mNaviDock->currentWidget()->property("url").toUrl();
        QAction *curAct = nullptr;
        for(QAction *act: mToolBar->actions()) {
            if(act->property("url").toUrl() == url) {
                curAct = act;
                break;
            }
        }
        if(curAct) {
            if(pos == 0) {
                curAct->setChecked(false);
            } else {
                curAct->setChecked(true);
            }
        }
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

void MainWindow::onCurrentPageChanged(const QUrl &url)
{
    const QUrlQuery query{url.query()};
    mCurLabel->setText(QString("Chatting with %1 ...").arg(query.queryItemValue("title")));
}
