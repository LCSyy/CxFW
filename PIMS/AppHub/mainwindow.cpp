#include "mainwindow.h"
#include <QApplication>
#include <QMenu>
#include <QProcess>
#include <QQuickWidget>

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
    , m_view(new QQuickWidget(QUrl("qrc:/main.qml"), this))
{
    m_view->setResizeMode(QQuickWidget::SizeRootObjectToView);
    setCentralWidget(m_view);

    resize(800,600);
}

MainWindow::~MainWindow()
{
}

void MainWindow::setupTrayIcon(const QIcon &icon)
{
    QMenu *menu = new QMenu(this);

    menu->addAction("Writer");
    menu->addAction("Messenger");
    menu->addAction("SnapNote");
    menu->addSeparator();
    menu->addAction("AppHub");
    menu->addAction("About ...");
    menu->addSeparator();
    menu->addAction("Quit", qApp, SLOT(quit()));

    menu->setStyleSheet(STYLE_SHEETS);

    QSystemTrayIcon *trayIcon = new QSystemTrayIcon(icon, this);
    trayIcon->setContextMenu(menu);

    connect(trayIcon, SIGNAL(activated(QSystemTrayIcon::ActivationReason)),
            this, SLOT(onTrayIconActivated(QSystemTrayIcon::ActivationReason)));

    trayIcon->show();
}

void MainWindow::onTrayIconActivated(QSystemTrayIcon::ActivationReason reason)
{
    if (QSystemTrayIcon::DoubleClick == reason) {
        show();
    }
}
