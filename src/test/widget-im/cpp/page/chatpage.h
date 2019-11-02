#ifndef CHATPAGE_H
#define CHATPAGE_H

#include <QWidget>

QT_BEGIN_NAMESPACE
class QQuickWidget;
QT_END_NAMESPACE
class ChatMsgModel;

struct Message;
class ChatPage : public QWidget
{
    Q_OBJECT
public:
    explicit ChatPage(QWidget *parent = nullptr);

private slots:
    void onSendMessage(const QString &msgUrl);
    void onMessageReadyRead(const Message &msg);

private:
    QQuickWidget *mQuick {nullptr};
    ChatMsgModel *mChatMsgModel {nullptr};
};

#endif // CHATPAGE_H
