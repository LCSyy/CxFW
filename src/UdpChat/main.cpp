#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QDir>
#include "udpchat.h"

QJSValue udpChatSingleton(QQmlEngine *qml, QJSEngine *js) {
    Q_UNUSED(qml)
    return js->newQObject(new UdpChat(js));
}

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);

    QQuickStyle::addStylePath("CxFw/CxStyle");
    qmlRegisterSingletonType("UChat", 0, 1, "UdpChat", udpChatSingleton);

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
