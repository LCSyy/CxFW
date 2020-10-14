#include <QApplication>
#include <QMenu>
#include <QSystemTrayIcon>
#include <QProcess>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    QMenu menu;
    menu.addAction("Snippet",[](){ QProcess::execute("andy-app.exe"); });
    menu.addSeparator();
    menu.addAction("Quit",[&a](){ a.quit(); });
    QSystemTrayIcon trayIcon(&a);
    trayIcon.setIcon(QIcon(":/icon/andy-service.png"));
    trayIcon.setContextMenu(&menu);
    trayIcon.show();
    return a.exec();
}

