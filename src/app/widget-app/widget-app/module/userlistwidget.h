#ifndef USERLISTWIDGET_H
#define USERLISTWIDGET_H

#include <QWidget>

QT_BEGIN_NAMESPACE
class QListWidget;
QT_END_NAMESPACE

class UserListWidget : public QWidget
{
    Q_OBJECT
public:
    explicit UserListWidget(QWidget *parent = nullptr);

private:
    QListWidget *mUserLst {nullptr};
};

#endif // USERLISTWIDGET_H
