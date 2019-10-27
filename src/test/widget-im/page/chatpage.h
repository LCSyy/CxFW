#ifndef CHATPAGE_H
#define CHATPAGE_H

#include <QWidget>

QT_BEGIN_NAMESPACE
class QQuickWidget;
QT_END_NAMESPACE
class ChatMsgModel;

class ChatPage : public QWidget
{
    Q_OBJECT
public:
    explicit ChatPage(QWidget *parent = nullptr);

private slots:
    void onSendMessage(const QString &msgUrl);
private:
    QQuickWidget *mQuick {nullptr};
    ChatMsgModel *mChatMsgModel {nullptr};
};

#endif // CHATPAGE_H
