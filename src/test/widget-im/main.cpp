#include "mainwindow.h"

#include <QApplication>
#include "login/loginwidget.h"
#include "globalkv.h"

#include <QDebug>

void onQuit() {
    GlobalKV::destroy();
}

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setWindowIcon(QIcon(":/ArrowOnly32x.png"));
    QObject::connect(&a, &QApplication::aboutToQuit,&onQuit);

    LoginWidget *login = new LoginWidget;
    int accept = login->exec();
    delete login;

    if(accept) {
        MainWindow win;
        win.show();
        return a.exec();
    } else {
        a.quit();
        return 0;
    }
}
