#include <QApplication>
#include "mainwindow.h"
#include "login/loginwidget.h"
#include "globalkv.h"
#include "im/messenger.h"

#include <QDebug>

void onInit() {
    Messenger::instance()->init();
}

void onQuit() {
    Messenger::drop();
    GlobalKV::destroy();
}

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setWindowIcon(QIcon(":/ArrowOnly32x.png"));
    QObject::connect(&a, &QApplication::aboutToQuit,&onQuit);

    onInit();

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
