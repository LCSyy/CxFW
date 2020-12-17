#include "mainwindow.h"
#include <QApplication>
#include <QMenu>
#include <QProcess>

namespace {
const char *STYLE_SHEETS = R"(
QMenu {
    background-color: white;
    color: black;
}
QMenu::item:selected {
    background-color: gray;
}
)";
}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    setupTrayIcon();
    resize(800,600);
}

MainWindow::~MainWindow()
{
}

void MainWindow::sendMsg(const QString &msg)
{
    if (msg == QStringLiteral("writer")) {
//        QProcess *writer = new QProcess(qApp);
//        writer->setProgram("writer.exe");
//        writer->start();
//        m_children.append(writer);
    } else if (msg == QStringLiteral("quit")) {
        for (QProcess *p : m_children) {
            if (p && p->state() != QProcess::NotRunning) {
                p->close();
                p->waitForFinished();
            }
        }
        m_children.clear();
        qApp->quit();
    }
}

void MainWindow::onTrayIconActivated(QSystemTrayIcon::ActivationReason reason)
{
    if (QSystemTrayIcon::DoubleClick == reason) {
        show();
    }
}

void MainWindow::setupTrayIcon()
{
    QMenu *menu = new QMenu(this);

    menu->addAction("Writer", [this](){ this->sendMsg("writer"); });
    menu->addAction("Messenger", [this](){ this->sendMsg("messenger"); });
    menu->addAction("SnapNote", [this](){ this->sendMsg("snapnote"); });
    menu->addSeparator();
    menu->addAction("AppHub", this, SLOT(show()));
    menu->addAction("About ...", [this](){ this->sendMsg("abountapphub"); });
    menu->addSeparator();
    menu->addAction("Quit", [this](){ this->sendMsg("quit"); });

    menu->setStyleSheet(STYLE_SHEETS);

    QSystemTrayIcon *trayIcon = new QSystemTrayIcon(QIcon(":/res/Icons/AppHubIcon.png"), this);
    trayIcon->setContextMenu(menu);

    connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(onTrayIconActivated(QSystemTrayIcon::ActivationReason)));

    trayIcon->show();
}
