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

    QTextEdit *textedit = new QTextEdit(this);
    vlayout->addWidget(textedit);

    QToolBar *bottombar = new QToolBar(this);
    vlayout->addWidget(bottombar);

    QPushButton *sendBtn = new QPushButton("Send",bottombar);
    bottombar->addWidget(sendBtn);
}
