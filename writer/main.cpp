#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSettings>

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
