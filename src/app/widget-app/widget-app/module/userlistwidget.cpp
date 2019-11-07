#include "userlistwidget.h"
#include <QVBoxLayout>
#include <QListWidget>
#include <QListWidgetItem>

UserListWidget::UserListWidget(QWidget *parent)
    : QWidget(parent)
{
    QVBoxLayout *vlayout = new QVBoxLayout(this);
    vlayout->setMargin(0);
    vlayout->setSpacing(0);

    mUserLst = new QListWidget(this);
    vlayout->addWidget(mUserLst);

    mUserLst->addItems({"Acker","Bkk","Ckj","Des","Eol"});
}
