#include "pagecontainer.h"
#include <QVBoxLayout>
#include <QTabBar>
#include <QStackedWidget>
#include <QVariantMap>
#include <QUrl>
#include <QUrlQuery>
#include "page/chatpage.h"
#include "page/settingpage.h"

#include <QDebug>

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
    const QString path = url.path();

    bool foundPage = false;
    mTabBar->blockSignals(true);
    if(path == "chat") {
        foundPage = openChatPage(url);
    } else if(path == "settings") {
        foundPage = openSettingsPage(url);
    }

    mTabBar->blockSignals(false);
    if(foundPage && oldUrl != url) {
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
        if(pageUrl.path() == "chat") {
            int chatCount{0};
            for(int i = 0; i < mTabBar->count(); ++i) {
                if(mTabBar->tabData(i).toMap().value("url").toUrl().path() == "chat") {
                    chatCount += 1;
                }
            }
            if(chatCount == 0) {
                mPageStack->removeWidget(wgt);
                delete wgt;
                wgt = nullptr;
            }
            break;
        } else if(pageUrl == url) {
            mPageStack->removeWidget(wgt);
            delete wgt;
            wgt = nullptr;
            break;
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

bool PageContainer::openChatPage(const QUrl &url)
{
    bool foundPage {false};
    const QUrlQuery query(url.query());
    const QString who = query.queryItemValue("who");
    const QString title = query.queryItemValue("title");

    // find or create tab
    // find or create page
    bool foundTab{false};
    for(int i = 0; i < mTabBar->count(); ++i) {
        const QVariantMap tabMap = mTabBar->tabData(i).toMap();
        const QUrl tabUrl = tabMap.value("url").toUrl();
        if(tabUrl == url) {
            foundTab = true;
            mTabBar->setCurrentIndex(i);
            break;
        }
    }

    if(!foundTab) {
        foundTab = true;
        QUrlQuery query(url.query());
        int idx = mTabBar->addTab(query.queryItemValue("title"));
        QVariantMap dataMap;
        dataMap.insert("url",QVariant::fromValue(url));
        mTabBar->setTabData(idx,QVariant::fromValue(dataMap));
        mTabBar->setCurrentIndex(idx);
    }

    for(int i = 0; i < mPageStack->count(); ++i) {
        QWidget *page = mPageStack->widget(i);
        if(page) {
            const QUrl pageUrl = page->property("url").toUrl();
            if(pageUrl.path() == "chat") {
                foundPage = true;
                mPageStack->setCurrentIndex(i);
                ChatPage *chatWgt = qobject_cast<ChatPage*>(page);
                if(chatWgt) {
                    // ... load who's chatting data ...
                }
                break;
            }
        }
    }

    if(!foundPage) {
        foundPage = true;
        ChatPage *chatWgt = new ChatPage(mPageStack);
        chatWgt->setProperty("url",url);
        mPageStack->addWidget(chatWgt);
        mPageStack->setCurrentWidget(chatWgt);
    }

    return foundPage;
}

bool PageContainer::openSettingsPage(const QUrl &url)
{
    bool foundPage {false};
    const QUrlQuery query(url.query());
    const QString who = query.queryItemValue("who");
    const QString title = query.queryItemValue("title");

    // find or create tab
    // find or create page
    bool foundTab{false};
    for(int i = 0; i < mTabBar->count(); ++i) {
        const QVariantMap tabMap = mTabBar->tabData(i).toMap();
        const QUrl tabUrl = tabMap.value("url").toUrl();
        if(tabUrl == url) {
            foundTab = true;
            mTabBar->setCurrentIndex(i);
            break;
        }
    }

    if(!foundTab) {
        foundTab = true;
        QUrlQuery query(url.query());
        int idx = mTabBar->addTab(query.queryItemValue("title"));
        QVariantMap dataMap;
        dataMap.insert("url",QVariant::fromValue(url));
        mTabBar->setTabData(idx,QVariant::fromValue(dataMap));
        mTabBar->setCurrentIndex(idx);
    }

    for(int i = 0; i < mPageStack->count(); ++i) {
        QWidget *page = mPageStack->widget(i);
        if(page) {
            const QUrl pageUrl = page->property("url").toUrl();
            if(pageUrl.path() == "settings") {
                foundPage = true;
                mPageStack->setCurrentIndex(i);
                SettingPage *settingWgt = qobject_cast<SettingPage*>(page);
                if(settingWgt) {
                    // ... visual at setting fragment ...
                }
                break;
            }
        }
    }

    if(!foundPage) {
        foundPage = true;
        SettingPage *settingWgt = new SettingPage(mPageStack);
        settingWgt->setProperty("url",url);
        mPageStack->addWidget(settingWgt);
        mPageStack->setCurrentWidget(settingWgt);
    }

    return foundPage;
}
