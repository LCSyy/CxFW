#include <QQmlApplicationEngine>
#include "cxapp.h"

int main(int argc, char *argv[])
{
    CxApp::setup("Writer","0.0.1");
    QApplication app(argc, argv);
    CxApp a(&app);

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
