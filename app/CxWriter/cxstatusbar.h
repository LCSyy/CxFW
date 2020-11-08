#ifndef CXSTATUSBAR_H
#define CXSTATUSBAR_H

#include <QToolBar>

class CxStatusBar : public QToolBar
{
    Q_OBJECT
public:
    explicit CxStatusBar(QWidget *parent = nullptr);
};

#endif // CXSTATUSBAR_H
