#include "cxapp.h"
#include <QQmlApplicationEngine>
#include <QMenu>
#include <CxBinding/cxbinding.h>
#include "theme.h"
#include "listmodel.h"

namespace {
    static QJSValue themeSingleton(QQmlEngine *e, QJSEngine *s)
    {
        Q_UNUSED(e)
        return s->newQObject(new Theme(s));
    }

    static void qmlTypeRegister() {
        CxBinding::registerAll();
        qmlRegisterSingletonType(CxBinding::moduleName(),CxBinding::majorVersion(),CxBinding::minorVersion(),"Theme",themeSingleton);
        qmlRegisterType<ListModel>(CxBinding::moduleName(),CxBinding::majorVersion(),CxBinding::minorVersion(),"ListModel");
    }
}

void CxApp::setup(const QString &name, const QString &version)
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QCoreApplication::setOrganizationName("Lcs App");
    QCoreApplication::setOrganizationDomain("cxfw.lcs");
    QCoreApplication::setApplicationName(name);
    QCoreApplication::setApplicationVersion(version);
}

CxApp::CxApp(QApplication *app)
    : m_app(app)
{
    Q_ASSERT_X(m_app,"CxApp::init", "app is null");

#if !defined(QT_DEBUG)
    m_app->setQuitOnLastWindowClosed(false);
#endif

    ::qmlTypeRegister();
    // qmlRegisterSingletonInstance(CxBinding::moduleName(),CxBinding::majorVersion(),CxBinding::minorVersion(),"Sys", m_notify);

    initTrayIcon();
}

CxApp::~CxApp()
{
    if (m_trayMenu) {
        delete m_trayMenu;
    }
}

void CxApp::initTrayIcon()
{
    m_trayIcon = new QSystemTrayIcon(QIcon(":/icon/AppHubIcon.png"),m_app);
    m_trayMenu = new QMenu;

    QAction *actionQuit = new QAction(QObject::tr("Quit"),m_trayMenu);
    m_trayMenu->addAction(actionQuit);
    m_trayIcon->setContextMenu(m_trayMenu);

    QObject::connect(m_trayIcon,SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(onTrayActivated(QSystemTrayIcon::ActivationReason)));
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
}

