#ifndef CONTACTNAVI_H
#define CONTACTNAVI_H

#include "naviwidget.h"

class ContactNavi : public NaviWidget
{
    Q_OBJECT
public:
    explicit ContactNavi(QWidget *parent = nullptr);

    virtual QIcon icon() const;
    virtual QString text() const;
};

#endif // CONTACTNAVI_H
