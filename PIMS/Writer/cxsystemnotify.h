#ifndef CXSYSTEMNOTIFY_H
#define CXSYSTEMNOTIFY_H

#include <QObject>
#include <QSystemTrayIcon>

class CxSystemNotify: public QObject
{
    Q_OBJECT

signals:
    void systemTrayIconActivated(int reason, QPrivateSignal);

public:
    explicit CxSystemNotify(QObject *parent = nullptr);
    ~CxSystemNotify();

private slots:
    void onTrayActivated(QSystemTrayIcon::ActivationReason reason);
};

#endif // CXSYSTEMNOTIFY_H
