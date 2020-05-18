#include "mainwindow.h"
#include <QTextBrowser>
#include <QLineEdit>
#include <QPushButton>
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QToolBar>

#include <QShortcut>

#include <QByteArray>
#include <QDataStream>
#include <QPainter>
#include <cxbase/cxbase.h>

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
    QRWidget *qr = new QRWidget(this);
    QToolBar *toolBar = addToolBar("test");
    toolBar->addAction(tr("QR"),[qr](){
        qr->show();
    });

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

struct QRWidgetPrivate {
    cx::QRCode code{40};
};

QRWidget::QRWidget(QWidget *parent)
    : QWidget(parent,Qt::Dialog)
    , d(new QRWidgetPrivate)
{
    d->code = cx::CxBase::genQRcode(20,2,"SS...");
}

QRWidget::~QRWidget()
{
    if (d) { delete d; }
}

void QRWidget::paintEvent(QPaintEvent *event)
{
    Q_UNUSED(event)

    QPainter painter(this);
    int x = 10;
    int y = 10;
    for (int i = 0; i < 20; ++i) {
        for (int j = 0; j < 20; ++j) {
            if (d->code.modules.at(i*20+j)) {
                painter.fillRect(QRect(x*(i+1),y*(j+1),10,10),Qt::black);
            }
        }
    }

//    for (uint8_t y = 0; y < code.size; y++) {
//        for (uint8_t x = 0; x < code.size; x++) {
//            if (qrcode_getModule(&code, x, y)) {
//                cxCode.modules.setBit(x+code.size*y,true);
//            } else {
//                cxCode.modules.setBit(x+code.size*y,false);
//            }
//        }
//    }

}
