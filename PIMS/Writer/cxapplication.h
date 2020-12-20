#ifndef CXAPPLICATION_H
#define CXAPPLICATION_H

#include <QApplication>
#include <QSystemTrayIcon>

QT_BEGIN_NAMESPACE
class QMenu;
QT_END_NAMESPACE

class CxApplication: public QObject
{
    Q_OBJECT

signals:
    void systemTrayIconActivated(int reason, QPrivateSignal);

public:
    CxApplication(const QString &name, int argc, char *argv[]);
    ~CxApplication();

    int exec();

private slots:
    void onTrayActivated(QSystemTrayIcon::ActivationReason reason);

private:
    void initTrayIcon();

    void registerSingletonInstance();
    void registerSingletonTypes();
    void registerTypes();

private:
    QApplication *app {nullptr};
    QSystemTrayIcon *m_trayIcon {nullptr};
    QMenu *m_trayMenu {nullptr};
};

#endif // CXAPPLICATION_H
