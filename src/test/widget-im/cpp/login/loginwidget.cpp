#include "loginwidget.h"
#include <QCloseEvent>
#include <QVBoxLayout>
#include <QFormLayout>
#include <QLineEdit>
#include <QPushButton>
#include <QStatusBar>
#include <QLabel>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFile>
#include <QTextStream>

#include "cpp/im/messenger.h"

#include <QDebug>

namespace {
}

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
    connect(Messenger::instance(), SIGNAL(messageReadyRead(const Message&)),
            this, SLOT(onMessageReadyRead(const Message&)));
}

void LoginWidget::onLogin()
{
    accept();
    /*
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

    mStatusBar->showMessage(tr("waiting for login ..."));

    Message msg;
    msg.host = "127.0.0.1";
    msg.port = 11500;
    QDataStream ser(&msg.msg,QIODevice::WriteOnly);
    LoginMsg login;
    login.data = QString(R"({"login":{"user":"%1","password":"%2","timestamp":"","md5":"akjdfljak4545"}})").arg(userName).arg(password);
    login.size = login.data.size();
    ser << login.size;
    msg.msg.append(login.data);
    Messenger::instance()->sendMessage(msg);
    */
}

void LoginWidget::onMessageReadyRead(const Message &msg)
{
    QJsonObject loginInfo = QJsonDocument::fromJson(QByteArray().append(msg.msg)).object();

    if(loginInfo.value("result").toString() == "OK") {
        accept();
    } else {
        mStatusBar->showMessage(tr("User not exists!"),5000);
    }
}
