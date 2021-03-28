#include <QApplication>
#include <QSystemTrayIcon>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QMenu>
#include <QDir>
#include <QQuickStyle>
#include <QLocalServer>
#include <QLocalSocket>
#include <QSharedMemory>
#include <QTimer>

#include "universe.h"
#include "cxsettings.h"
#include "cxlistmodel.h"
#include "cxurls.h"
#include "cxnetwork.h"
#include "MarkdownSyntaxHighlighter/cxquicksyntaxhighlighter.h"
#include "QGlobalShortcut/qglobalshortcut.h"

#define URI "Universe"
#define MAJOR_VERSION 0
#define MINOR_VERSION 1

static void setSystemTrayIcon(Universe *sys, QMenu *menu);
static void registerTypes(Universe *sys);
static void setGlobalShortcut(Universe *sys, const QKeySequence &keyseq);
static bool setupSingletonApp(Universe *sys);

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
#if !defined(QT_DEBUG)
    a.setQuitOnLastWindowClosed(false);
#endif

    Universe *sys = new Universe(&a);
    if (!setupSingletonApp(sys)) {
        return a.exec();
    }

    setGlobalShortcut(sys, QKeySequence(Qt::CTRL + Qt::Key_T));

    QMenu *menu = new QMenu(nullptr);
    setSystemTrayIcon(sys, menu);
    registerTypes(sys);

    QDir dir = QDir::current();
    QQmlApplicationEngine engine;
    engine.addImportPath(dir.absoluteFilePath("plugins"));

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &a, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    QObject::connect(&a, &QApplication::aboutToQuit, &a, [&menu](){
        if (menu) { delete menu; menu = nullptr; }
    }, Qt::QueuedConnection);

    return a.exec();
}

void setSystemTrayIcon(Universe *sys, QMenu *menu) {
    Q_ASSERT_X(menu, __FUNCTION__, "QMenu 'menu' is null.");


    QSystemTrayIcon *trayIcon = new QSystemTrayIcon(QIcon(":/icons/Universe-logo.png"), sys);

    Universe *s = qobject_cast<Universe*>(sys);
    QObject::connect(trayIcon, &QSystemTrayIcon::activated,
                     s, [&s](QSystemTrayIcon::ActivationReason reason)
    {
        switch (reason) {
        case QSystemTrayIcon::DoubleClick:
            emit s->notify(QSystemTrayIcon::DoubleClick);
            break;
        default:;
        }
    });

    menu->addAction(QObject::tr("About Universe ..."));
    menu->addSeparator();
    menu->addAction(QObject::tr("Exit"), qApp, [](){ qApp->quit(); });

    trayIcon->setContextMenu(menu);
    trayIcon->show();
}

void registerTypes(Universe *sys) {
    qmlRegisterType<CxSettings>(URI, MAJOR_VERSION, MINOR_VERSION, "CxSettings");
    qmlRegisterType<CxListModel>(URI, MAJOR_VERSION, MINOR_VERSION, "CxListModel");
    qmlRegisterType<CxQuickSyntaxHighlighter>(URI, MAJOR_VERSION, MINOR_VERSION, "CxSyntaxHighlighter");
    qmlRegisterType<QGlobalShortcut>(URI, MAJOR_VERSION, MINOR_VERSION, "CxGlobalShortcut");

    qmlRegisterSingletonInstance(URI, MAJOR_VERSION, MINOR_VERSION, "Sys", sys);

    CxSettings *s = new CxSettings(sys);
    qmlRegisterSingletonInstance(URI, MAJOR_VERSION, MINOR_VERSION, "CxSettings", s);

    const QString host = s->get("host").toString();
    const int port = s->get("port").toInt();
    CxUrls *url = new CxUrls("https", host, port, "writer", sys);
    qmlRegisterSingletonInstance(URI, MAJOR_VERSION, MINOR_VERSION, "URLs", url);

    CxNetwork *network = new CxNetwork(sys);
    qmlRegisterSingletonInstance(URI, MAJOR_VERSION, MINOR_VERSION, "CxNetwork", network);
}

void setGlobalShortcut(Universe *sys, const QKeySequence &keyseq) {
    QGlobalShortcut *shortcut = new QGlobalShortcut(keyseq, sys);
    QObject::connect(shortcut,&QGlobalShortcut::activated, sys, [&sys](){
        emit sys->notify(Universe::GlobalShorcut);
    });
}

bool setupSingletonApp(Universe *sys) {
    QLocalServer *srv = new QLocalServer(sys);
    QLocalSocket *sock = new QLocalSocket(sys);

    const QString name = QString("%1.cxfw.liu").arg(QCoreApplication::applicationName());
    QSharedMemory *lock = new QSharedMemory(name, sys);
    if (!lock->create(1)) {
        srv->deleteLater();
        QObject::connect(sock, &QLocalSocket::connected, qApp, &QApplication::quit, Qt::QueuedConnection);
        sock->connectToServer(name);
        return false;
    } else {
        sock->deleteLater();
        QObject::connect(srv,&QLocalServer::newConnection, sys, [sys, srv](){
            QLocalSocket *sock = srv->nextPendingConnection();
            if (sock) {
                sock->deleteLater();
            }
            emit sys->notify(Universe::ActiveByRun);
        });

        if (!srv->listen(name)) {
            QTimer::singleShot(1000, qApp, &QApplication::quit);
            return false;
        }
    }

    return true;
}
