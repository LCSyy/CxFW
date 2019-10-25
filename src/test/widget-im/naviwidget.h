#ifndef NAVIWIDGET_H
#define NAVIWIDGET_H

#include <QWidget>

class NaviWidget : public QWidget
{
    Q_OBJECT
public:
    explicit NaviWidget(QWidget *parent = nullptr);

    virtual QIcon icon() const;
    virtual QString text() const;
};

#endif // NAVIWIDGET_H
