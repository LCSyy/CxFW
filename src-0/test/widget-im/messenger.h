#ifndef MESSENGER_H
#define MESSENGER_H

#include <QObject>
#include <QDataStream>

QT_BEGIN_NAMESPACE
class QTcpSocket;
QT_END_NAMESPACE

struct LoginMsg {
    int size;
    QString data;

    friend QDataStream &operator<<(QDataStream &ds, const LoginMsg &msg) {
        ds << msg.size << msg.data.toLocal8Bit();
        return ds;
    }
};

struct Message
{
    QString host;
    quint16 port;
    QByteArray msg;
};

class Messenger : public QObject
{
    Q_OBJECT
signals:
    void messageReadyRead(const Message &msg);

public:
    static Messenger *instance();
    static void drop();

    void init();
    void destroy();

public slots:
    void sendMessage(const Message &msg);
    void sendRawMessage(const char *msg, qint64 size);

protected:
    Q_DISABLE_COPY(Messenger)
    explicit Messenger(QObject *parent = nullptr);

private slots:
    void onReadyRead();

private:
    QTcpSocket *mSocket {nullptr};
};

#endif // MESSENGER_H
