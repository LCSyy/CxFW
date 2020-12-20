#include "mainwindow.h"

#include <QApplication>
#include <CxBinding/cxbinding.h>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setQuitOnLastWindowClosed(false);

    CxBinding::registerAll();

    MainWindow w;
    w.setupTrayIcon(QIcon(":/res/Icons/AppHubIcon.png"));
    w.show();

    return a.exec();
}

