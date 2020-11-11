#include "cxapplication.h"
#include <QSystemTrayIcon>
#include <QMenu>

CxApplication::CxApplication(int argc, char *argv[])
    : QApplication(argc,argv)
{
    initTrayIcon();
}

CxApplication::~CxApplication()
{
    if (m_trayMenu) {
        delete m_trayMenu;
    }
}

void CxApplication::initTrayIcon()
{
    m_trayIcon = new QSystemTrayIcon(QIcon(":/icon/system_tray.png"),this);
    m_trayMenu = new QMenu;

    QAction *actionQuit = new QAction(QObject::tr("Quit"),m_trayMenu);
    m_trayMenu->addAction(actionQuit);
    m_trayIcon->setContextMenu(m_trayMenu);

    QObject::connect(actionQuit, SIGNAL(triggered()), this,SLOT(quit()), Qt::QueuedConnection);

    m_trayIcon->show();
}
