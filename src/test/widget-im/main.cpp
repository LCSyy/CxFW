#include <QApplication>
#include "cpp/mainwindow.h"
#include "cpp/login/loginwidget.h"
#include "cpp/globalkv.h"
#include "cpp/im/messenger.h"

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
        // onQuit();
        a.quit();
        return 0;
    }
}
