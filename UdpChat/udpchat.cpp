#include "udpchat.h"
#include <QUdpSocket>

#include <QHostInfo>
#include <QHostAddress>
#include <QNetworkDatagram>

#include <QNetworkInterface>
#include <QNetworkAddressEntry>

constexpr quint16 PORT = 32213;

UdpChat::UdpChat(QObject *parent)
    : QObject(parent)
    , mSocket(new QUdpSocket(this))
{
    connect(mSocket, &QUdpSocket::readyRead, this, &UdpChat::onReadyRead);

//    for (const QHostAddress &addr : QNetworkInterface::allAddresses()) {
//        qDebug() << "host:" << addr;
//    }

//    for (const QNetworkInterface &inf: QNetworkInterface::allInterfaces()) {
//        qDebug() << QString("=== %1 ===").arg(inf.name());
//        for (const QNetworkAddressEntry &entry: inf.addressEntries()) {
//            qDebug() << entry.broadcast();
//            qDebug() << entry.ip();
//            qDebug() << entry.netmask();
//        }
//    }
}

UdpChat::~UdpChat()
{

}

void UdpChat::setHost(const QString &host)
{
    mHost.setAddress(host);
    mSocket->bind(mHost, PORT);
}

void UdpChat::setSubnet(const QString &net)
{
    QStringList netInfo = net.split("/");
    if (netInfo.size() > 0) {
        mHost.setAddress(netInfo.value(0));
    }
}

QStringList UdpChat::hostAddrs() const
{
    QStringList hosts;
    QHostInfo info = QHostInfo::fromName(QHostInfo::localHostName());
    for (const QHostAddress &addr: info.addresses()) {
        if (addr.isInSubnet(mHost, mSubnetMask)) {
            hosts.append(addr.toString());
        }
    }

    return hosts;
}

void UdpChat::sendMsg(const QString &peer, const QString &msg)
{
    QByteArray ba;
    ba.append(static_cast<char>(Msg::ChatInfo));
    ba.append(msg.toUtf8());

    mSocket->writeDatagram(ba,QHostAddress(peer), PORT);
}

void UdpChat::sendBroadCast()
{
    qDebug() << "broad cast";
    QByteArray ba;
    ba.append(static_cast<char>(Msg::Search));
    ba.append(mHost.toString().toUtf8());
    mSocket->writeDatagram(ba, QHostAddress::Broadcast, PORT);
}

void UdpChat::onReadyRead()
{
    qDebug() << "OnReadyRead";
    while(mSocket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = mSocket->receiveDatagram();
        const QByteArray ba = datagram.data();
        if (ba.size() > 0) {
            const char msg = ba.at(0);
            const QString info = QString::fromUtf8(ba.right(ba.size()-1));
            emit msgReady(msg, datagram.senderAddress().toString(), info);
        }
    }
}
