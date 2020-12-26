#include "cxapplication.h"
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
}

CxApplication::CxApplication(const QString &name, int argc, char *argv[]) {
    QCoreApplication::setOrganizationName("Lcs App");
    QCoreApplication::setOrganizationDomain("cxfw.lcs");
    QCoreApplication::setApplicationName(name);

    app = new QApplication(argc,argv);

#if !defined(QT_DEBUG)
    app->setQuitOnLastWindowClosed(false);
    initTrayIcon();
#endif

    CxBinding::registerAll();
    registerSingletonTypes();
    registerTypes();
    registerSingletonInstance();
}

CxApplication::~CxApplication()
{
    if (m_trayMenu) {
        delete m_trayMenu;
    }

    if (app) {
        delete app;
    }
}

int CxApplication::exec()
{
    return app->exec();
}

void CxApplication::onTrayActivated(QSystemTrayIcon::ActivationReason reason)
{
    switch(reason) {
    case QSystemTrayIcon::DoubleClick:
        break;
    default:
        ;
    }

    emit systemTrayIconActivated(reason, QPrivateSignal{});
}

void CxApplication::initTrayIcon()
{
    m_trayIcon = new QSystemTrayIcon(QIcon(":/icon/AppHubIcon.png"),this);
    m_trayMenu = new QMenu;

    QAction *actionQuit = new QAction(QObject::tr("Quit"),m_trayMenu);
    m_trayMenu->addAction(actionQuit);
    m_trayIcon->setContextMenu(m_trayMenu);

    connect(m_trayIcon,SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(onTrayActivated(QSystemTrayIcon::ActivationReason)));
    connect(actionQuit, SIGNAL(triggered()), app, SLOT(quit()), Qt::QueuedConnection);

    m_trayIcon->show();
}

void CxApplication::registerSingletonInstance()
{
     qmlRegisterSingletonInstance(CxBinding::moduleName(),CxBinding::majorVersion(),CxBinding::minorVersion(),"App", this);
}

void CxApplication::registerSingletonTypes()
{
     qmlRegisterSingletonType(CxBinding::moduleName(),CxBinding::majorVersion(),CxBinding::minorVersion(),"Theme",themeSingleton);
}

void CxApplication::registerTypes()
{
     qmlRegisterType<ListModel>(CxBinding::moduleName(),CxBinding::majorVersion(),CxBinding::minorVersion(),"ListModel");
}
