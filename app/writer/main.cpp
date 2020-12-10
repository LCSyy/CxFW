#include <QQmlApplicationEngine>
#include <QSettings>
#include "cxapplication.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("Lcs App");
    QCoreApplication::setOrganizationDomain("cxfw.lcs");
    QCoreApplication::setApplicationName("writer");

    CxApplication app(argc, argv);

    QQmlApplicationEngine engine;
    {
        QSettings s(engine.offlineStorageDatabaseFilePath("writer.db") + ".ini",QSettings::IniFormat);
        const QString v = s.value("Version","0.0.1").toString();
        engine.globalObject().setProperty("DBVersion",v);
    }

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
