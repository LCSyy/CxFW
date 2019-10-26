#include "contactnavi.h"
#include <QVBoxLayout>
#include <QListWidget>
#include <QUrl>

ContactNavi::ContactNavi(QWidget *parent)
    : NaviWidget(parent)
{
    QVBoxLayout *ccLayout = new QVBoxLayout(this);
    ccLayout->setMargin(0);
    ccLayout->setSpacing(0);

    QListWidget *lstWgt = new QListWidget(this);

    QListWidgetItem *item1 = new QListWidgetItem("Bb",lstWgt);
    item1->setData(Qt::UserRole+1,QVariant::fromValue(QString("1")));
    lstWgt->addItem(item1);

    QListWidgetItem *item2 = new QListWidgetItem("LLy",lstWgt);
    item2->setData(Qt::UserRole+1,QVariant::fromValue(QString("2")));
    lstWgt->addItem(item2);

    QListWidgetItem *item3 = new QListWidgetItem("Acc",lstWgt);
    item3->setData(Qt::UserRole+1,QVariant::fromValue(QString("3")));
    lstWgt->addItem(item3);

    ccLayout->addWidget(lstWgt,1);

    connect(lstWgt, SIGNAL(itemDoubleClicked(QListWidgetItem*)),
            this, SLOT(onItemDoubleClicked(QListWidgetItem*)));
}

void ContactNavi::onItemDoubleClicked(QListWidgetItem *item)
{
    const QString contactUname = item->data(Qt::UserRole + 1).toString();
    QUrl url{QString("chat?who=%1&title=%2").arg(contactUname).arg(item->text())};
    emit contactDoubleClicked(url);
}
