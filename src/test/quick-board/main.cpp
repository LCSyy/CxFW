#include <QGuiApplication>
#include <QQuickWindow>
#include <QQmlApplicationEngine>
#include <QJSValue>
#include "networkmanager.h"
#include "silencestyle.h"
#include "wanderstyle.h"

static QJSValue networkManagerProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    return scriptEngine->newQObject(new NetworkManager(engine));
}

static QJSValue silenceStyleProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    return scriptEngine->newQObject(new SilenceStyle(engine));
}

static QJSValue wanderStyleProvider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    return scriptEngine->newQObject(new WanderStyle(engine));
}

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setOrganizationName("cxfw");
    QCoreApplication::setOrganizationDomain("lcs.cxfw");
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/ArrowOnly32x.png"));

    QQuickWindow::setTextRenderType(QQuickWindow::NativeTextRendering);

    qmlRegisterSingletonType("QuickBoard",1,0,"NetworkManager",networkManagerProvider);
    qmlRegisterSingletonType("SilenceStyle",1,0,"Silence",silenceStyleProvider);
    qmlRegisterSingletonType("WanderStyle",1,0,"Wander",wanderStyleProvider);

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
