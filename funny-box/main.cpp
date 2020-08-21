#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <bqrcode.h>
#include <iostream>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    BQRCode qrcode;
    for (const uint8_t code: qrcode.genQRCode("This is a test.",1)) {
        if (code == 1) {
            std::cout << "*";
        } else if (code == 0) {
            std::cout << " ";
        } else {
            std::cout << std::endl;
        }
    }

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
