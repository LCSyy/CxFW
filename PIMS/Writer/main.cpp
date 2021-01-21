#include <QQmlApplicationEngine>
#include <CxApp/cxapp.h>
#include <QQuickStyle>
#include <QDir>
#include <QDialog>
#include <QLabel>
#include <QDebug>

int main(int argc, char *argv[])
{
    CxApp::setup("Writer","0.0.1");
    QApplication app(argc, argv);
    CxApp a(&app);

    if(a.setupSingleInstance()) {
        QDir dir = QDir::current();
        QQuickStyle::addStylePath(dir.absoluteFilePath("plugins/CxQuick/Controls/CxFw"));
        QQmlApplicationEngine engine;
        engine.addImportPath(dir.absoluteFilePath("plugins"));
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
