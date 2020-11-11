#ifndef CXAPPLICATION_H
#define CXAPPLICATION_H

#include <QApplication>
#include <QSystemTrayIcon>

QT_BEGIN_NAMESPACE
class QMenu;
QT_END_NAMESPACE

class CxApplication: public QApplication
{
    Q_OBJECT

signals:
    void systemTrayIconActivated(int reason, QPrivateSignal);

public:
    CxApplication(int argc, char *argv[]);
    ~CxApplication();

private slots:
    void onTrayActivated(QSystemTrayIcon::ActivationReason reason);

private:
    void initTrayIcon();

    void registerSingletonInstance();
    void registerSingletonTypes();
    void registerTypes();

private:
    QSystemTrayIcon *m_trayIcon;
    QMenu *m_trayMenu;
};

#endif // CXAPPLICATION_H
