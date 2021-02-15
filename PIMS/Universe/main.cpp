#include <QApplication>
#include <QSystemTrayIcon>
#include <QQmlApplicationEngine>
#include <QMenu>
#include <QDir>
#include <QQuickStyle>

#include "cxsettings.h"
#include "cxlistmodel.h"
#include "cxurls.h"

static void setSystemTrayIcon(QObject *w, QMenu *menu);
static void registerTypes(QObject *parent);

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QCoreApplication::setOrganizationName("LcsApps");
    QCoreApplication::setOrganizationDomain("cxfw.lcs");
    QCoreApplication::setApplicationName("Universe");
    QCoreApplication::setApplicationVersion("0.0.1");

    QApplication a(argc, argv);
    QMenu *menu = new QMenu(nullptr);
    setSystemTrayIcon(&a, menu);

    registerTypes(&a);

    QDir dir = QDir::current();
//    QQuickStyle::addStylePath(dir.absoluteFilePath("plugins/CxQuick/Controls/CxFw"));
    QQmlApplicationEngine engine;
    engine.addImportPath(dir.absoluteFilePath("plugins"));

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &a, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    QObject::connect(&a, &QCoreApplication::aboutToQuit, &a, [&menu](){
        if (menu) {
            delete menu;
            menu = nullptr;
        }
    }, Qt::QueuedConnection);

    return a.exec();
}

void setSystemTrayIcon(QObject *w, QMenu *menu) {
    Q_ASSERT_X(menu, __FUNCTION__, "QMenu 'menu' is null.");

    QSystemTrayIcon *trayIcon = new QSystemTrayIcon(QIcon(":/icons/Universe-logo.png"), w);

    menu->addAction(QObject::tr("About Universe"));
    menu->addSeparator();
    menu->addAction(QObject::tr("Exit ..."));

    trayIcon->setContextMenu(menu);

    trayIcon->show();
}

void registerTypes(QObject *parent) {
    qmlRegisterType<CxSettings>("Universe", 0, 1, "CxSettings");
    qmlRegisterType<CxListModel>("Universe", 0, 1, "CxListModel");

    CxSettings *s = new CxSettings(parent);
    const QString host = s->get("host").toString();
    const int port = s->get("port").toInt();

    CxUrls *url = new CxUrls("https", host, port, "writer", parent);

    qmlRegisterSingletonInstance("Universe", 0, 1, "CxSettings", s);
    qmlRegisterSingletonInstance("Universe", 0, 1, "URLs", url);
}
