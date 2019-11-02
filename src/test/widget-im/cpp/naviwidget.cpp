#include "naviwidget.h"

NaviWidget::NaviWidget(QWidget *parent)
    : QWidget(parent)
{

}


void NaviWidget::setIcon(const QIcon &icon)
{
    mIcon = icon;
}

QIcon NaviWidget::icon() const
{
    return mIcon;
}


void NaviWidget::setText(const QString &text)
{
    mText = text;
}

QString NaviWidget::text() const
{
    return mText;
}
