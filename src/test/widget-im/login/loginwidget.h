#ifndef LOGINWIDGET_H
#define LOGINWIDGET_H

#include <QDialog>

QT_BEGIN_NAMESPACE
class QLineEdit;
class QStatusBar;
QT_END_NAMESPACE

class LoginWidget : public QDialog
{
    Q_OBJECT
public:
    explicit LoginWidget(QWidget *parent = nullptr);

private slots:
    void onLogin();

private:
    QLineEdit *mUserNameField {nullptr};
    QLineEdit *mPasswordField {nullptr};
    QStatusBar *mStatusBar {nullptr};
};

#endif // LOGINWIDGET_H
