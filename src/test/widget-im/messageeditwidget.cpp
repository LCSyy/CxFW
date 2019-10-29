#include "messageeditwidget.h"
#include <QToolBar>
#include <QVBoxLayout>
#include <QTextEdit>
#include <QPushButton>
#include <QKeySequence>
#include <QShortcut>
#include <QKeyEvent>
#include "globalkv.h"

#include <QDebug>

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

    connect(mSendBtn,SIGNAL(clicked(bool)),this,SLOT(onSendMsgClicked()));
}

void MessageEditWidget::onSendMsgClicked()
{
    const QString msg = mTextEdit->toPlainText();
    if(!msg.isEmpty()) {
        pGlobalKV->set(QStringLiteral("send_msg"),msg);
        mTextEdit->clear();
        emit sendMessage(QStringLiteral("send_msg"));
    }
}

void MessageEditWidget::keyPressEvent(QKeyEvent *event)
{
    if(event->key() == Qt::Key_Return) { // ctrl + enter
        mSendBtn->click();
    }
}
