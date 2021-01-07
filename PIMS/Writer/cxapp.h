#ifndef CXAPPLICATION_H
#define CXAPPLICATION_H

#include <QApplication>
#include <QSystemTrayIcon>

QT_BEGIN_NAMESPACE
class QMenu;
QT_END_NAMESPACE

class CxApp: public QObject
{
    Q_OBJECT

signals:
    void systemTrayIconActivated(int reason, QPrivateSignal);

public:
    static void setup(const QString &name, const QString &version);

    CxApp(QApplication *app);
    ~CxApp();

    void init(QApplication *app);
    void initTrayIcon();

private slots:
    void onTrayActivated(QSystemTrayIcon::ActivationReason reason);

private:
    QApplication *m_app {nullptr};
    QSystemTrayIcon *m_trayIcon {nullptr};
    QMenu *m_trayMenu {nullptr};
};


#endif // CXAPPLICATION_H
