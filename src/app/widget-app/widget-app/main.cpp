#include <QApplication>
#include <QQmlEngine>
#include "mainwindow.h"
#include "utils.h"
#include "textmetrics.h"

static QJSValue utils_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)

    Utils *utils = new Utils(scriptEngine);
    QJSValue utilsVal = scriptEngine->newQObject(utils);
    return utilsVal;
}

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);

    qmlRegisterSingletonType("CxIM", 1, 0, "Utils", utils_provider);

    qmlRegisterType<TextMetrics>("CxIM",1,0,"CxTextMetrics");

    MainWindow w;
    w.show();

    return a.exec();
}
