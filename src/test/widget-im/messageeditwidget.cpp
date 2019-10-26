#include "messageeditwidget.h"
#include <QToolBar>
#include <QVBoxLayout>
#include <QTextEdit>
#include <QPushButton>

MessageEditWidget::MessageEditWidget(QWidget *parent)
    : QWidget(parent)
{
    QVBoxLayout *vlayout = new QVBoxLayout(this);
    vlayout->setMargin(0);
    vlayout->setSpacing(0);

    QToolBar *toolbar = new QToolBar(this);
    vlayout->addWidget(toolbar);

    toolbar->addAction("emoji");

    mTextEdit = new QTextEdit(this);
    vlayout->addWidget(mTextEdit);

    QToolBar *bottombar = new QToolBar(this);
    vlayout->addWidget(bottombar);

    mSendBtn = new QPushButton("Send", bottombar);
    bottombar->addWidget(mSendBtn);

    connect(mSendBtn,SIGNAL(clicked(bool)),this,SIGNAL(sendMessage()));
}

QString MessageEditWidget::message() const
{
    return mTextEdit->toHtml();
}
