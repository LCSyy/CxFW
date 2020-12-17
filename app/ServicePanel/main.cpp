#include "mainwindow.h"

#include <QApplication>
#include <QSystemTrayIcon>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    QSystemTrayIcon tray(QIcon(""),&a);

    MainWindow w;
    w.show();

    return a.exec();
}
