#ifndef LOGINWIDGET_H
#define LOGINWIDGET_H

#include <QDialog>

class LoginWidget : public QDialog
{
    Q_OBJECT
public:
    explicit LoginWidget(QWidget *parent = nullptr);

private slots:
    void onLogin();

private:

};

#endif // LOGINWIDGET_H
