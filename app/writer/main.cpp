#include <QQmlApplicationEngine>
#include <QSettings>
#include <QSystemTrayIcon>
#include <QMenu>

#include <QDebug>

#include <QGlobalShortcut/qglobalshortcut.h>
#include "cxapplication.h"
#include "theme.h"
#include "listmodel.h"
#include "cxquicksyntaxhighlighter.h"

static void registerSingletonType();
static void registerTypes();
static QJSValue themeSingleton(QQmlEngine *e, QJSEngine *s);

#define CXQUICK "CxQuick"
#define CXQUICK_VERSION_MARJOR 0
#define CXQUICK_VERSION_MINOR 1

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("Lcs App");
    QCoreApplication::setOrganizationDomain("cxfw.lcs");
    QCoreApplication::setApplicationName("writer");

    CxApplication app(argc, argv);
    app.setQuitOnLastWindowClosed(false);

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
    qmlRegisterSingletonType(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"Theme",themeSingleton);
}

static void registerTypes() {
    qmlRegisterType<ListModel>(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"ListModel");
    qmlRegisterType<CxQuickSyntaxHighlighter>(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"SyntaxHighlighter");
    qmlRegisterType<QGlobalShortcut>(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"GlobalShortcut");
}

static QJSValue themeSingleton(QQmlEngine *e, QJSEngine *s)
{
    Q_UNUSED(e)
    return s->newQObject(new Theme(s));
}
