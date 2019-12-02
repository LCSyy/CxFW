#include <QApplication>
#include "mainwindow.h"
#include "messenger.h"

#include <QDebug>

void onInit() {
    Messenger::instance()->init();
}

void onQuit() {
    Messenger::drop();
}

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setWindowIcon(QIcon(":/ArrowOnly32x.png"));
    QObject::connect(&a, &QApplication::aboutToQuit,&onQuit);

    onInit();

    MainWindow win;
    win.show();

    return a.exec();
}
