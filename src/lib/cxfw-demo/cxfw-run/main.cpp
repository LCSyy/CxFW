#include <QCoreApplication>
#include <QTimer>
#include <cxfw-demo/cxfw.h>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    CxFW cxfw;
    cxfw.sayHi();

    QTimer::singleShot(100, [&a](){ a.quit(); });

    return a.exec();
}
