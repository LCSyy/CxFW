#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "curveitem.h"
#include "edgeitem.h"
#include "cxlistmodel.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    qmlRegisterType<CurveItem>("VPL", 0, 1, "CurveItem");
    qmlRegisterType<EdgeItem>("VPL", 0, 1, "EdgeItem");
    qmlRegisterType<CxListModel>("CxQuick", 0, 1, "CxListModel");

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
