#include "chatwidget.h"
#include <QVBoxLayout>
#include <QHBoxLayout>
#include <QSplitter>
#include <QTextEdit>
#include <QPushButton>
#include <QToolBar>
#include <QQuickWidget>

ChatWidget::ChatWidget(QWidget *parent)
    : QWidget(parent)
{
    QVBoxLayout *vlayout = new QVBoxLayout(this);
    vlayout->setMargin(0);
    vlayout->setSpacing(0);

    QQuickWidget *chatView = new QQuickWidget(this);
    vlayout->addWidget(chatView);

    chatView->setResizeMode(QQuickWidget::SizeRootObjectToView);
    chatView->setSource(QUrl("qrc:/qml/ChatView.qml"));
}
