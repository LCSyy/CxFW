#include "loginwidget.h"
#include <QCloseEvent>
#include <QVBoxLayout>
#include <QFormLayout>
#include <QLineEdit>
#include <QPushButton>
#include <QWindow>

#include <QTcpSocket>

#include <QDebug>

LoginWidget::LoginWidget(QWidget *parent)
    : QDialog(parent)
{
    setWindowFlag(Qt::WindowContextHelpButtonHint,false);
    setAttribute(Qt::WA_QuitOnClose);
    setWindowTitle(tr("widget-im login"));

    QVBoxLayout *vlayout = new QVBoxLayout(this);
    QFormLayout *formLayout = new QFormLayout;
    vlayout->addLayout(formLayout);
    QLineEdit *userNameField = new QLineEdit(this);
    QLineEdit *passwordField = new QLineEdit(this);
    formLayout->addRow(tr("Name"),userNameField);
    formLayout->addRow(tr("Password"),passwordField);
    QPushButton *loginBtn = new QPushButton(tr("login"),this);
    vlayout->addWidget(loginBtn);

    connect(loginBtn,SIGNAL(clicked()),this,SLOT(onLogin()));
}

void LoginWidget::onLogin()
{
    QTcpSocket socket;
    socket.connectToHost("127.0.0.1",11511);

    if (socket.waitForConnected(1000)) {
        socket.write("login://user:password@host:port/path/?param=value#fragment");
        socket.flush();
    }

    if(socket.waitForReadyRead()) {
        if(socket.readAll() == QByteArray("Ok")) {
            accept();
        }
    }
}
