#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <andy-core/localstorage.h>
#include "liststoragemodel.h"
#include "backend.h"

QJSValue registerBackend(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
    Q_UNUSED(qmlEngine)
    return jsEngine->newQObject(new Backend);
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QObject::connect(&app,&QGuiApplication::aboutToQuit,[](){
        LocalStorage::drop();
    });

    qmlRegisterType<ListStorageModel>("Andy.Model",1,0,"ListStorageModel");
    qmlRegisterSingletonType("Andy",1,0,"Backend",registerBackend);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
