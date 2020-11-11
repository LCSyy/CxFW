#ifndef CXAPPLICATION_H
#define CXAPPLICATION_H

#include <QApplication>

QT_BEGIN_NAMESPACE
class QMenu;
class QSystemTrayIcon;
QT_END_NAMESPACE

class CxApplication: public QApplication
{
    Q_OBJECT
public:
    CxApplication(int argc, char *argv[]);
    ~CxApplication();

private:
    void initTrayIcon();

private:
    QSystemTrayIcon *m_trayIcon;
    QMenu *m_trayMenu;
};

#endif // CXAPPLICATION_H
