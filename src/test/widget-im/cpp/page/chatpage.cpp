#include "chatpage.h"
#include <QSplitter>
#include <QVBoxLayout>
#include <QQuickWidget>
#include <QQmlContext>
#include <QJSEngine>
#include <QDateTime>
#include <QJsonDocument>
#include <QJsonObject>
#include "cpp/globalkv.h"
#include "cpp/chatitem.h"
#include "cpp/utility.h"
#include "cpp/textmetrics.h"
#include "cpp/chatmsgmodel.h"
#include "cpp/messageeditwidget.h"
#include "cpp/im/messenger.h"

#include <QDebug>

namespace {
    static QJSValue utility_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        return scriptEngine->newQObject(new Utility(scriptEngine));
    }
}

ChatPage::ChatPage(QWidget *parent) : QWidget(parent)
{
    QVBoxLayout *vlayout = new QVBoxLayout(this);
    vlayout->setMargin(0);
    vlayout->setSpacing(0);

    QSplitter *splitter = new QSplitter(this);
    splitter->setOrientation(Qt::Vertical);
    vlayout->addWidget(splitter);

    qmlRegisterSingletonType("CxIM",1,0,"Utils",::utility_provider);
    qmlRegisterType<ChatItem>("CxIM",1,0,"ChatItem");
    qmlRegisterType<TextMetrics>("CxIM",1,0,"TextMetrics");

    mQuick = new QQuickWidget(splitter);
    mQuick->setResizeMode(QQuickWidget::SizeRootObjectToView);
    QQmlContext *ctx = mQuick->rootContext();
    if(ctx) {
        mChatMsgModel = new ChatMsgModel(this);
        ctx->setContextProperty("chatMsgModel", mChatMsgModel);
    }
    mQuick->setSource(QUrl("qrc:/qml/ChatFlow.qml"));

    MessageEditWidget *msgEdit = new MessageEditWidget(splitter);
    msgEdit->setMinimumHeight(150);
    splitter->addWidget(mQuick);
    splitter->addWidget(msgEdit);
    splitter->setStretchFactor(0,1);
    splitter->setSizes({splitter->height() - 150,150});

    connect(msgEdit,SIGNAL(sendMessage(const QString&)),
            this, SLOT(onSendMessage(const QString&)));
    connect(Messenger::instance(),SIGNAL(messageReadyRead(const Message&)),
            this, SLOT(onMessageReadyRead(const Message&)));
}

void ChatPage::onSendMessage(const QString &msgUrl)
{
    const QString msg = pGlobalKV->value(msgUrl).toString();
    QVariantMap chatMap;
    const QString dt = QDateTime::currentDateTime().toString("MM-dd hh:mm");
    chatMap.insert("who","ME");
    chatMap.insert("name","LCS");
    chatMap.insert("color","#963147");
    chatMap.insert("dt",dt);
    chatMap.insert("msg",msg);
    mChatMsgModel->addMessage(chatMap);
    QString chatMsg = QString(R"({"type":2,"user":"LCS","msg":"%1"})").arg(msg);
    Messenger::instance()->sendMessage({"127.0.0.1",11500,chatMsg});
}

void ChatPage::onMessageReadyRead(const Message &msg)
{
    QJsonObject chatMsg = QJsonDocument::fromJson(QByteArray().append(msg.msg)).object();
    QVariantMap chatMap;
     const QString dt = QDateTime::currentDateTime().toString("MM-dd hh:mm");
     chatMap.insert("who","L");
     chatMap.insert("name",msg.host + ":" + QString::number(msg.port));
     chatMap.insert("color","#008080");
     chatMap.insert("dt",dt);
     chatMap.insert("msg",QString(chatMsg.value("msg").toString()));
     mChatMsgModel->addMessage(chatMap);
}
