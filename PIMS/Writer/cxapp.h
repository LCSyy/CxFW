#ifndef CXAPPLICATION_H
#define CXAPPLICATION_H

#include <QApplication>
#include <QSystemTrayIcon>

QT_BEGIN_NAMESPACE
class QMenu;
QT_END_NAMESPACE

class QGlobalShortcut;
class CxApp: public QObject
{
    Q_OBJECT

public:
    enum NotifyReason {
        // 0 - 4 is trayicon active reason
        GlobalShorcut = QSystemTrayIcon::MiddleClick + 1,
    };

signals:
    void systemNotify(int reason, QPrivateSignal);

public:
    static void setup(const QString &name, const QString &version);

    CxApp(QApplication *app);
    ~CxApp();

private:
    void initTrayIcon();
    void initShortcut();

private slots:
    void onTrayActivated(QSystemTrayIcon::ActivationReason reason);

private:
    QApplication *m_app {nullptr};
    QSystemTrayIcon *m_trayIcon {nullptr};
    QMenu *m_trayMenu {nullptr};
    QGlobalShortcut *m_shortcut {nullptr};
};


#endif // CXAPPLICATION_H
