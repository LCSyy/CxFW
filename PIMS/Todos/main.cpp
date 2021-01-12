#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <CxApp/cxapp.h>
#include <CxCore/cxurls.h>
#include <QSettings>

int main(int argc, char *argv[])
{
    CxApp::setup("Todos","0.0.1");
    QApplication app(argc, argv);
    CxApp a(&app);

    QSettings settings;

    QQmlApplicationEngine engine;
    QQmlContext *ctx = engine.rootContext();
    ctx->setContextProperty("URLs", new CxUrls("https",
                                               settings.value("host").toString(),
                                               settings.value("port").toInt(),
                                               "todos",
                                               ctx)
                            );
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
