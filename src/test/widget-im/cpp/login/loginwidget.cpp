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

#include "cpp/im/messenger.h"

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
    connect(Messenger::instance(), SIGNAL(messageReadyRead(const Message&)),
            this, SLOT(onMessageReadyRead(const Message&)));
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

    mStatusBar->showMessage(tr("waiting for login ..."));

    Messenger::instance()->sendMessage({"127.0.0.1",11500,
                                        QString(R"({"type":1,"usr":"%1","pwd":"%2"})").arg(userName).arg(password)});
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
