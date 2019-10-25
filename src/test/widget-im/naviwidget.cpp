#include "naviwidget.h"
#include <QIcon>

NaviWidget::NaviWidget(QWidget *parent)
    : QWidget(parent)
{

}

QIcon NaviWidget::icon() const
{
    return QIcon();
}

QString NaviWidget::text() const
{
    return QString("Act");
}
