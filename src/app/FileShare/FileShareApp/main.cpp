#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QHostInfo>
#include <QHostAddress>
#include <QDnsLookup>
#include <QDnsHostAddressRecord>

#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QDnsLookup lookup;
    lookup.setType(QDnsLookup::A);
    lookup.setName(QHostInfo::localHostName());
    QObject::connect(&lookup,&QDnsLookup::finished,[&lookup](){
        for (const QDnsHostAddressRecord &r: lookup.hostAddressRecords()) {
            if (r.value().isGlobal()) {
                qDebug() << "name:" << r.name();
                qDebug() << "value:" << r.value();
            }
        }
    });

    lookup.lookup();

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
