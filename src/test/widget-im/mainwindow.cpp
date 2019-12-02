#include "mainwindow.h"
#include <QTextBrowser>
#include <QLineEdit>
#include <QPushButton>
#include <QVBoxLayout>
#include <QHBoxLayout>

#include <QShortcut>

#include <QByteArray>
#include <QDataStream>

#include "messenger.h"

#include <QDebug>

#define MSG_FORMAT(color,who,msg) QString("<br/><b style=color:"#color">"#who": </b>"#msg)

struct Msg {
    ushort version;
    ushort type;
    int len;
    char *data;

    friend QDataStream &operator<<(QDataStream &ds, const Msg &msg) {
        ds << msg.version << msg.type
           << msg.len << msg.data;
        return ds;
    }
};

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , mTextBrowser(new QTextBrowser(this))
    , mInputField(new QLineEdit(this))
{
    QWidget *wgt = new QWidget(this);
    setCentralWidget(wgt);

    QVBoxLayout *vlayout = new QVBoxLayout(wgt);
    vlayout->addWidget(mTextBrowser);

    QHBoxLayout *hlayout = new QHBoxLayout;
    hlayout->setMargin(0);
    vlayout->addLayout(hlayout);

    hlayout->addWidget(mInputField);

    QPushButton *sendBtn = new QPushButton(tr("send"),wgt);
    hlayout->addWidget(sendBtn);

    sendBtn->setShortcut(QKeySequence(Qt::CTRL + Qt::Key_Return));

    connect(sendBtn,SIGNAL(clicked()),this,SLOT(onSendMessage()));

    mTextBrowser->insertHtml(MSG_FORMAT(#991253,me,"This is message from me."));
    mTextBrowser->insertHtml(MSG_FORMAT(#134679,mengling,"Hi, are you there"));

    resize(800,450);
}

void MainWindow::onSendMessage()
{
    const QString msg = mInputField->text();
    mInputField->clear();

    Msg m;
    m.version = 1;
    m.type = 1;

    const std::string stdMsg = msg.toStdString();
    m.len = static_cast<int>(stdMsg.size());

    size_t dataSize = static_cast<size_t>(m.len);
    m.data = reinterpret_cast<char*>(malloc(dataSize));
    memcpy_s(m.data,dataSize,stdMsg.data(),stdMsg.size());

    QByteArray ba;
    QDataStream stream(&ba,QIODevice::WriteOnly);
    stream.setByteOrder(QDataStream::BigEndian);
    stream << m;

    free(m.data);

    Messenger::instance()->sendRawMessage(ba.data(),ba.size());
}
