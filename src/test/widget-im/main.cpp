#include "mainwindow.h"

#include <QApplication>
#include "globalkv.h"

void onQuit() {
    GlobalKV::destroy();
}

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setWindowIcon(QIcon(":/ArrowOnly32x.png"));
    MainWindow w;
    w.show();

    QObject::connect(&a, &QApplication::aboutToQuit,&onQuit);

    return a.exec();
}

