#ifndef UDPCHAT_H
#define UDPCHAT_H

#include <QObject>
#include <QHostAddress>

QT_BEGIN_NAMESPACE
class QUdpSocket;
QT_END_NAMESPACE

enum class Msg {
    Unknown = 0,
    Hello,
    Bye,
    Pending,
    Search,
};

class UdpChat : public QObject
{
    Q_OBJECT

signals:
    void msgReady(char msgType, const QString &peer, quint16 port, const QString &info);

public:
    explicit UdpChat(QObject *parent = nullptr);
    ~UdpChat() override;

    Q_INVOKABLE QStringList hostAddrs() const;

public slots:
    void setHost(const QString &host);
    void setSubnet(const QString &net);

    void sendMsg(const QString &peer, const QString &msg);
    void sendBroadCast();

protected slots:
    void onReadyRead();

protected:
    QUdpSocket *mSocket {nullptr};

    QHostAddress mSubnet;
    int mSubnetMask {24};
};

#endif // UDPCHAT_H
