#include <QQmlApplicationEngine>
#include <QSettings>
#include <QApplication>
#include <CxBinding/cxbinding.h>
#include "theme.h"
#include "listmodel.h"

static QJSValue themeSingleton(QQmlEngine *e, QJSEngine *s)
{
    Q_UNUSED(e)
    return s->newQObject(new Theme(s));
}

static void registerSingletonTypes()
{
     qmlRegisterSingletonType(CxBinding::moduleName(),CxBinding::majorVersion(),CxBinding::minorVersion(),"Theme",themeSingleton);
}

static void registerTypes()
{
     qmlRegisterType<ListModel>(CxBinding::moduleName(),CxBinding::majorVersion(),CxBinding::minorVersion(),"ListModel");
}


int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
//    CxApplication app("Writer", argc, argv);

    QCoreApplication::setOrganizationName("Lcs App");
    QCoreApplication::setOrganizationDomain("cxfw.lcs");
    QCoreApplication::setApplicationName("Writer");
    QApplication app(argc, argv);

    CxBinding::registerAll();
    registerTypes();
    registerSingletonTypes();

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
