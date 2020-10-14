#include "application.h"

#include <functional>

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "util.h"
#include "httpaccessmanager.h"

namespace {

void registerQuickSingletonType() {

    qmlRegisterSingletonType("App",1,0,"Util", [](QQmlEngine*,QJSEngine *scriptEngine) -> QJSValue {
        return scriptEngine->newQObject(new Util);
    });
}

void registerQuickTypes() {
    qmlRegisterType<HttpAccessManager>("App",1,0,"HttpAccessManager");
}

}

Application::Application(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    app = new QGuiApplication(argc,argv);

    registerQuickSingletonType();
    registerQuickTypes();
}

int Application::exec()
{
    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app->exec();
}

