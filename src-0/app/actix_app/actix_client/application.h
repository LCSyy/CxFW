#ifndef APPLICATION_H
#define APPLICATION_H

#include <QtGlobal>

QT_BEGIN_NAMESPACE
class QGuiApplication;
QT_END_NAMESPACE

class Application
{
public:
    Application(int argc, char *argv[]);

    int exec();
private:
    QGuiApplication *app{nullptr};
};

#endif // APPLICATION_H
