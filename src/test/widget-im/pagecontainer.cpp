#include "pagecontainer.h"
#include <QVBoxLayout>
#include <QTabBar>
#include <QStackedWidget>
#include <QVariantMap>
#include <QUrl>
#include <QUrlQuery>
#include "page/chatpage.h"

PageContainer::PageContainer(QWidget *parent)
    : QWidget(parent)
{
    QVBoxLayout *vlayout = new QVBoxLayout(this);
    vlayout->setMargin(0);
    vlayout->setSpacing(0);

    mTabBar = new QTabBar(this);
    mTabBar->setExpanding(false);
    mTabBar->setTabsClosable(true);
    mTabBar->setStyleSheet("QTabBar::tab{min-width:150px;}");
    vlayout->addWidget(mTabBar);

    mPageStack = new QStackedWidget(this);
    vlayout->addWidget(mPageStack);

    connect(mTabBar, SIGNAL(tabCloseRequested(int)),
            this, SLOT(onTabCloseRequested(int)));
    connect(mTabBar, SIGNAL(currentChanged(int)),
            this, SLOT(onTabCurrentChanged(int)));
}

void PageContainer::openPage(const QUrl &url)
{
    const QUrl oldUrl = currentPage();

    bool found {false};
    for(int i = 0; i < mTabBar->count(); ++i) {
        const QVariantMap tabMap = mTabBar->tabData(i).toMap();
        const QUrl tabUrl = tabMap.value("url").toUrl();
        if(tabUrl == url) {
            found = true;
            mTabBar->setCurrentIndex(i);
            break;
        }
    }

    if(!found) {
        QUrlQuery query(url.query());
        mTabBar->blockSignals(true);
        int idx = mTabBar->addTab(query.queryItemValue("title"));
        mTabBar->blockSignals(false);
        QVariantMap dataMap;
        dataMap.insert("url",QVariant::fromValue(url));
        mTabBar->setTabData(idx,QVariant::fromValue(dataMap));
        mTabBar->setCurrentIndex(idx);
    }

    // find or create page
    // ...

    const QString path = url.path();
    const QUrlQuery query(url.query());
    const QString who = query.queryItemValue("who");
    const QString title = query.queryItemValue("title");

    if(path == "chat") {
        found = false;
        for(int i = 0; i < mPageStack->count(); ++i) {
            QWidget *page = mPageStack->widget(i);
            if(page) {
                const QUrl pageUrl = page->property("url").toUrl();
                if(pageUrl.path() == "chat") {
                    found = true;
                    ChatPage *chatWgt = qobject_cast<ChatPage*>(page);
                    if(chatWgt) {
                        // ... load who's chatting data ...
                    }
                    break;
                }
            }
        }
        if(!found) {
            ChatPage *chatWgt = new ChatPage(mPageStack);
            chatWgt->setProperty("url",QUrl(QString("chat?who=%1").arg(who)));
            mPageStack->addWidget(chatWgt);
        }
    } else if(path == "group") {

    } else if(path == "news") {

    }

    if(oldUrl != url) {
        emit currentPageChanged(url);
    }
}

void PageContainer::closePage(const QUrl &url)
{
    const QUrl oldUrl = currentPage();

    for(int i = 0; i < mTabBar->count(); ++i) {
        if(mTabBar->tabData(i).toMap().value("url").toUrl() == url) {
            mTabBar->removeTab(i);
            break;
        }
    }

    for(int i = 0; i < mPageStack->count(); ++i) {
        QWidget *wgt = mPageStack->widget(i);
        const QUrl pageUrl = wgt->property("url").toUrl();
        if(url.path() == "chat") {
            int chatCount{0};
            for(int i = 0; i < mTabBar->count(); ++i) {
                if(mTabBar->tabData(i).toMap().value("url").toUrl().path() == "chat") {
                    chatCount += 1;
                }
            }
            if(chatCount == 0) {
                delete wgt;
                wgt = nullptr;
            }
        }
        else if(pageUrl == url) {
            delete wgt;
            wgt = nullptr;
        }
    }

    const QUrl newUrl = currentPage();
    if(oldUrl != newUrl) {
        emit currentPageChanged(newUrl);
    }
}

QUrl PageContainer::currentPage() const
{
    QWidget *page = mPageStack->currentWidget();
    if(page) {
        return page->property("url").toUrl();
    }
    return QUrl();
}

void PageContainer::onTabCloseRequested(int idx)
{
    if(idx == -1) { return; }

    const QUrl url = mTabBar->tabData(idx).toMap().value("url").toUrl();
    if(url.isValid()) { closePage(url); }
}

void PageContainer::onTabCurrentChanged(int idx)
{
    if(idx == -1) { return; }

    const QUrl url = mTabBar->tabData(idx).toMap().value("url").toUrl();
    if(url.isValid()) { openPage(url); }
}
