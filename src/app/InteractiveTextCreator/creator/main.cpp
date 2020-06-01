/*!

  Quick UI
  Models
  LocalStorage
*/
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDir>

#include <itcore/localstorage.h>
#include "trendsboardmodel.h"

#include <QDebug>

void registerTypes();
void onAppQuit();

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QObject::connect(&app,&QGuiApplication::aboutToQuit,onAppQuit);

    registerTypes();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    for (const QObject *const obj: engine.rootObjects()) {
        TrendsBoardModel *trendsBardModel = obj->findChild<TrendsBoardModel*>("trendsBoardModel");
        if (trendsBardModel) {
            for (const QVariant &item: LocalStorage::self().loadData("SELECT * FROM trends;")) {
                const QVariantMap itemMap = item.toMap();
                trendsBardModel->pushTrends(QList<TrendsBoardItem>{TrendsBoardItem{
                                                                       itemMap.value("uid").toLongLong(),
                                                                       itemMap.value("name").toString(),
                                                                       itemMap.value("title").toString(),
                                                                       itemMap.value("brief").toString()
                                                                   }});
            }
        }
    }

    return app.exec();
}

void registerTypes() {
    qmlRegisterType<TrendsBoardModel>("IT",1,0,"TrendsBoardModel");
}

void onAppQuit() {
    LocalStorage::drop();
}
