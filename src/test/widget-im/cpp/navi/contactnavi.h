#ifndef CONTACTNAVI_H
#define CONTACTNAVI_H

#include "naviwidget.h"

QT_BEGIN_NAMESPACE
class QListWidgetItem;
QT_END_NAMESPACE

class ContactNavi : public NaviWidget
{
    Q_OBJECT
signals:
    void contactDoubleClicked(const QUrl &url);

public:
    explicit ContactNavi(QWidget *parent = nullptr);

private slots:
    void onItemDoubleClicked(QListWidgetItem *item);
};

#endif // CONTACTNAVI_H
