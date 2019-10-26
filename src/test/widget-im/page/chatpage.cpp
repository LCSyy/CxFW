#include "chatpage.h"
#include <QSplitter>
#include <QVBoxLayout>
#include "messageeditwidget.h"

ChatPage::ChatPage(QWidget *parent) : QWidget(parent)
{
    QVBoxLayout *vlayout = new QVBoxLayout(this);
    vlayout->setMargin(0);
    vlayout->setSpacing(0);

    QSplitter *splitter = new QSplitter(this);
    splitter->setOrientation(Qt::Vertical);
    vlayout->addWidget(splitter);

    QWidget *contentWgt = new QWidget(splitter);
    contentWgt->setStyleSheet("background:#123456");

    MessageEditWidget *msgEdit = new MessageEditWidget(splitter);
    msgEdit->setMinimumHeight(150);

    splitter->addWidget(contentWgt);
    splitter->addWidget(msgEdit);
    splitter->setStretchFactor(0,1);
}
