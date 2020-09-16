#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>

#include "theme.h"
#include "listmodel.h"

static void registerSingletonType();
static void registerTypes();
static QJSValue themeSingleton(QQmlEngine *e, QJSEngine *s);

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setApplicationName("writer");

    QGuiApplication app(argc, argv);

    registerSingletonType();
    registerTypes();

    QQmlApplicationEngine engine;
    engine.globalObject().setProperty("AppVersion","0.0.1");
    engine.globalObject().setProperty("AppDbVersion","0.0.6");
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

static void registerSingletonType() {
    qmlRegisterSingletonType("App.Type",1,0,"Theme",themeSingleton);
}

static void registerTypes() {
    qmlRegisterType<ListModel>("App.Type",1,0,"ListModel");
}

static QJSValue themeSingleton(QQmlEngine *e, QJSEngine *s)
{
    Q_UNUSED(e)
    return s->newQObject(new Theme(s));
}
