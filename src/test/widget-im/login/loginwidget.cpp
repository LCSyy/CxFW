#include "loginwidget.h"
#include <QCloseEvent>
#include <QVBoxLayout>
#include <QFormLayout>
#include <QLineEdit>
#include <QPushButton>
#include <QStatusBar>
#include <QLabel>

#include "im/messenger.h"

#include <QDebug>

LoginWidget::LoginWidget(QWidget *parent)
    : QDialog(parent)
    , mUserNameField(new QLineEdit(this))
    , mPasswordField(new QLineEdit(this))
    , mStatusBar(new QStatusBar(this))
{
    setWindowFlag(Qt::WindowContextHelpButtonHint,false);
    setAttribute(Qt::WA_QuitOnClose);
    setWindowTitle(tr("widget-im login"));
    setFixedSize(300,200);

    QVBoxLayout *vlayout = new QVBoxLayout(this);
    QLabel *label = new QLabel(this);
    label->setTextFormat(Qt::RichText);
    label->setText("<b style=color:#DC143C;font-size:xx-large>Widget-IM</b>");
    label->setAlignment(Qt::AlignCenter);
    vlayout->addWidget(label,1);
    QFormLayout *formLayout = new QFormLayout;
    vlayout->addLayout(formLayout);
    formLayout->addRow(tr("name"), mUserNameField);
    formLayout->addRow(tr("password"), mPasswordField);
    QPushButton *loginBtn = new QPushButton(tr("login"),this);
    vlayout->addWidget(loginBtn);
    mStatusBar->setSizeGripEnabled(false);
    vlayout->addWidget(mStatusBar);

    connect(loginBtn,SIGNAL(clicked()),this,SLOT(onLogin()));
}

void LoginWidget::onLogin()
{
    const QString userName = mUserNameField->text().trimmed();
    const QString password = mPasswordField->text().trimmed();
    if(userName.isEmpty()) {
        mStatusBar->showMessage(tr("username cant be empty"),5000);
    //    return;
    }
    if(password.isEmpty()) {
        mStatusBar->showMessage(tr("password cant be empty"),5000);
    //    return;
    }

    Messenger::instance()->sendMessage({"127.0.0.1",11500,"Hello"});
    // QTcpSocket socket;
    // socket.connectToHost("192.168.2.119", 11511);
    //
    // if (socket.waitForConnected(1000)) {
    //     socket.write(R"({"name":"AA","password":"123"})");
    //     socket.flush();
    // }
    //
    // if(socket.waitForReadyRead()) {
    //     if(socket.readAll() == QByteArray("Ok")) {
             accept();
    //     }
    // }
}
