#include "contactnavi.h"
#include <QIcon>
#include <QVBoxLayout>
#include <QListWidget>

ContactNavi::ContactNavi(QWidget *parent)
    : NaviWidget(parent)
{
    QVBoxLayout *ccLayout = new QVBoxLayout(this);
    ccLayout->setMargin(0);
    ccLayout->setSpacing(0);

    QListWidget *lstWgt = new QListWidget(this);
    lstWgt->addItem("Bb");
    lstWgt->addItem("Uyho");
    lstWgt->addItem("lly");
    ccLayout->addWidget(lstWgt,1);
}

QIcon ContactNavi::icon() const
{
    return QIcon();
}

QString ContactNavi::text() const
{
    return QString("CC");
}
