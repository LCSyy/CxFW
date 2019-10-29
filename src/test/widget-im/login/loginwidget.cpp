﻿#include "loginwidget.h"
#include <QCloseEvent>
#include <QVBoxLayout>
#include <QFormLayout>
#include <QLineEdit>
#include <QPushButton>
#include <QStatusBar>
#include <QLabel>

#include <QTcpSocket>

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
    label->setText("<b style=color:#123456;font-size:xx-large>Widget-IM</b>");
    label->setAlignment(Qt::AlignCenter);
    vlayout->addWidget(label,1);
    QFormLayout *formLayout = new QFormLayout;
    vlayout->addLayout(formLayout);
    formLayout->addRow(tr("Name"), mUserNameField);
    formLayout->addRow(tr("Password"), mPasswordField);
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
        return;
    }
    if(password.isEmpty()) {
        mStatusBar->showMessage(tr("password cant be empty"),5000);
        return;
    }

    QTcpSocket socket;
    socket.connectToHost("127.0.0.1", 11511);

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
