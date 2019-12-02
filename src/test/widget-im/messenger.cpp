#include "messenger.h"
#include <QTcpSocket>
#include <QHostAddress>

#define SERVER_HOST "127.0.0.1"
#define SERVER_PORT 7878

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
        mSocket->bind(QHostAddress(QHostAddress::LocalHost),11510);
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
    msg.msg = mSocket->readAll();
    emit messageReadyRead(msg);
}

void Messenger::sendMessage(const Message &msg)
{
    if(mSocket->state() != QAbstractSocket::ConnectedState) {
        mSocket->connectToHost(SERVER_HOST,SERVER_PORT,QIODevice::ReadWrite);
    }
    if(mSocket->waitForConnected()) {
        mSocket->write(msg.msg);
        mSocket->waitForBytesWritten();
    }
}

void Messenger::sendRawMessage(const char *msg, qint64 size)
{
    if(mSocket->state() != QAbstractSocket::ConnectedState) {
        mSocket->connectToHost(SERVER_HOST,SERVER_PORT,QIODevice::ReadWrite);
    }
    if(mSocket->waitForConnected()) {
        mSocket->write(msg,size);
        mSocket->waitForBytesWritten();
    }
}
