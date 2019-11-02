#include "messenger.h"
#include <QTcpSocket>
#include <QHostAddress>

static Messenger *msg_socket {nullptr};

Messenger *Messenger::instance()
{
    if(!msg_socket) {
        msg_socket = new Messenger;
    }
    return msg_socket;
}

void Messenger::drop()
{
    if(msg_socket) {
        msg_socket->destroy();
        delete msg_socket;
    }
    msg_socket = nullptr;
}

void Messenger::init()
{
    if(!mSocket) {
        mSocket = new QTcpSocket(this);
        connect(mSocket,SIGNAL(readyRead()),this,SLOT(onReadyRead()));
        mSocket->bind(QHostAddress(QHostAddress::LocalHost),11501);
    }
}

void Messenger::destroy()
{
    if(mSocket) {
        mSocket->disconnectFromHost();
    }
}

Messenger::Messenger(QObject *parent)
    : QObject(parent)
{

}

void Messenger::onReadyRead()
{
    Message msg;
    msg.host = mSocket->peerName();
    msg.port = mSocket->peerPort();
    msg.msg = QString(mSocket->readAll());
    emit messageReadyRead(msg);
}

void Messenger::sendMessage(const Message &msg)
{
    mSocket->connectToHost(msg.host,msg.port,QIODevice::ReadWrite);
    if(mSocket->waitForConnected()) {
        mSocket->write(QByteArray().append(msg.msg));
        mSocket->waitForBytesWritten();
    }
}
