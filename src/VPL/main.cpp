#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QDir>
#include "curveitem.h"
#include "edgeitem.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQuickStyle::addStylePath("CxFw/CxStyle");

    qmlRegisterType<CurveItem>("VPL", 0, 1, "CurveItem");
    qmlRegisterType<EdgeItem>("VPL", 0, 1, "EdgeItem");

    QQmlApplicationEngine engine;
    engine.addImportPath(QDir::current().absoluteFilePath("."));

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
