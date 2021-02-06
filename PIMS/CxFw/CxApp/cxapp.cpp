#include "cxapp.h"
#include <QSharedMemory>
#include <QMenu>
#include <QTimer>
#include <QQmlApplicationEngine>
#include <QLocalServer>
#include <QLocalSocket>
// #include <CxBinding/cxbinding.h>
#include <QGlobalShortcut/qglobalshortcut.h>

void CxApp::setup(const QString &name, const QString &version)
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QCoreApplication::setOrganizationName("LcsApps");
    QCoreApplication::setOrganizationDomain("cxfw.lcs");
    QCoreApplication::setApplicationName(name);
    QCoreApplication::setApplicationVersion(version);
}

CxApp::CxApp(QApplication *app)
    : m_app(app)
{
    Q_ASSERT_X(m_app, "CxApp::init", "app is null");
     qmlRegisterSingletonInstance("CxQuick.App", 0, 1,
                                  "Sys", this);
}

CxApp::~CxApp()
{
    if (m_trayMenu) {
        delete m_trayMenu;
    }
}

void CxApp::setGlobalShortcut(const QKeySequence &keyseq)
{
    m_shortcut = new QGlobalShortcut(keyseq, this);
     connect(m_shortcut,&QGlobalShortcut::activated, this, [this](){
         emit systemNotify(GlobalShorcut, QPrivateSignal{});
     });
}

bool CxApp::setupSingleInstance()
{
    QLocalServer *srv = new QLocalServer(this);
    QLocalSocket *sock = new QLocalSocket(this);

    const QString name = QString("%1.cxfw.liu").arg(QCoreApplication::applicationName());
    QSharedMemory *lock = new QSharedMemory(name, this);
    if (!lock->create(1)) {
        srv->deleteLater();
        QObject::connect(sock, &QLocalSocket::connected, m_app, &QApplication::quit, Qt::QueuedConnection);
        sock->connectToServer(name);
        return false;
    } else {
        sock->deleteLater();
        QObject::connect(srv,&QLocalServer::newConnection, m_app, [this, srv](){
            QLocalSocket *sock = srv->nextPendingConnection();
            if (sock) {
                sock->deleteLater();
            }
            emit this->systemNotify(ActiveByRun,QPrivateSignal{});
        });

        if (!srv->listen(name)) {
            QTimer::singleShot(1000, m_app, SLOT(quit()));
            return false;
        }
    }

    return true;
}

void CxApp::initTrayIcon(bool quitOnClose)
{
    m_app->setQuitOnLastWindowClosed(quitOnClose);

    m_trayIcon = new QSystemTrayIcon(QIcon(QString(":/icons/%1-logo.png").arg(QCoreApplication::applicationName())),m_app);
    m_trayMenu = new QMenu;

    QAction *actionPopup = new QAction(tr("Popup"), m_trayMenu);
    QAction *actionQuit = new QAction(tr("Quit"),m_trayMenu);
    m_trayMenu->addAction(actionPopup);
    m_trayMenu->addSeparator();
    m_trayMenu->addAction(actionQuit);
    m_trayIcon->setContextMenu(m_trayMenu);

    QObject::connect(m_trayIcon,SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(onTrayActivated(QSystemTrayIcon::ActivationReason)));
    QObject::connect(actionPopup, &QAction::triggered, this, [this](){
        emit systemNotify(QSystemTrayIcon::DoubleClick, QPrivateSignal{});
    });
    QObject::connect(actionQuit, SIGNAL(triggered()), m_app, SLOT(quit()), Qt::QueuedConnection);

    m_trayIcon->show();
}

// do nothing yet.
void CxApp::onTrayActivated(QSystemTrayIcon::ActivationReason reason)
{
    switch(reason) {
    case QSystemTrayIcon::DoubleClick:
        break;
    default:
        ;
    }

    emit systemNotify(reason, QPrivateSignal{});
}

