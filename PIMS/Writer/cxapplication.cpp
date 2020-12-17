#include "cxapplication.h"
#include <QQmlApplicationEngine>
#include <QMenu>

#include <QGlobalShortcut/qglobalshortcut.h>
#include "theme.h"
#include "listmodel.h"
#include "cxquicksyntaxhighlighter.h"

#define CXQUICK "CxQuick"
#define CXQUICK_VERSION_MARJOR 0
#define CXQUICK_VERSION_MINOR 1

namespace {
    static QJSValue themeSingleton(QQmlEngine *e, QJSEngine *s)
    {
        Q_UNUSED(e)
        return s->newQObject(new Theme(s));
    }
}

CxApplication::CxApplication(int argc, char *argv[])
    : QApplication(argc,argv)
{

#if !defined(QT_DEBUG)
    setQuitOnLastWindowClosed(false);
    initTrayIcon();
#endif

    registerSingletonTypes();
    registerTypes();
    registerSingletonInstance();
}

CxApplication::~CxApplication()
{
    if (m_trayMenu) {
        delete m_trayMenu;
    }
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
    m_trayIcon = new QSystemTrayIcon(QIcon(":/icon/system_tray.png"),this);
    m_trayMenu = new QMenu;

    QAction *actionQuit = new QAction(QObject::tr("Quit"),m_trayMenu);
    m_trayMenu->addAction(actionQuit);
    m_trayIcon->setContextMenu(m_trayMenu);


    connect(m_trayIcon,SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(onTrayActivated(QSystemTrayIcon::ActivationReason)));
    connect(actionQuit, SIGNAL(triggered()), this,SLOT(quit()), Qt::QueuedConnection);

    m_trayIcon->show();
}

void CxApplication::registerSingletonInstance()
{
    qmlRegisterSingletonInstance(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"App",this);
}

void CxApplication::registerSingletonTypes()
{
    qmlRegisterSingletonType(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"Theme",themeSingleton);
}

void CxApplication::registerTypes()
{
    qmlRegisterType<ListModel>(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"ListModel");
    qmlRegisterType<CxQuickSyntaxHighlighter>(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"SyntaxHighlighter");
    qmlRegisterType<QGlobalShortcut>(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"GlobalShortcut");
}
