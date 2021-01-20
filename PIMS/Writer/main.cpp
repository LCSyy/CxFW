#include <QQmlApplicationEngine>
#include <CxApp/cxapp.h>

int main(int argc, char *argv[])
{
    CxApp::setup("Writer","0.0.1");
    QApplication app(argc, argv);
    CxApp a(&app);

    if(a.setupSingleInstance()) {
        QQmlApplicationEngine engine;
        engine.addImportPath("F://dev/cxfw/cxfw/PIMS/dist/bin/plugins");
        const QUrl url(QStringLiteral("qrc:/main.qml"));
        QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                         &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
        engine.load(url);

        return app.exec();
    }

    return app.exec();
}
