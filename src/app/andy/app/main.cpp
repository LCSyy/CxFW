#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "liststoragemodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QObject::connect(&app,&QGuiApplication::aboutToQuit,[](){
        // LocalStorage::drop();
    });

    qmlRegisterType<ListStorageModel>("Andy.Model",1,0,"ListStorageModel");

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
