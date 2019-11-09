#include <QApplication>
#include <QQmlEngine>
#include "mainwindow.h"
#include "textmetrics.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    qmlRegisterType<TextMetrics>("CxIM",1,0,"CxTextMetrics");

    MainWindow w;
    w.show();

    return a.exec();
}
