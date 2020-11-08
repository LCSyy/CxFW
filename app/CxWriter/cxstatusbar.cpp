#include "cxstatusbar.h"
#include <QLayout>

#include <QDebug>

CxStatusBar::CxStatusBar(QWidget *parent)
    : QToolBar(parent)
{
    setAllowedAreas(Qt::BottomToolBarArea);
    setFloatable(false);
    setMovable(false);
}
