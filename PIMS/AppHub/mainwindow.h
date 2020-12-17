#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QSystemTrayIcon>

QT_BEGIN_NAMESPACE
class QProcess;
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:
    void sendMsg(const QString &msg);

private slots:
    void onTrayIconActivated(QSystemTrayIcon::ActivationReason reason);
    // void onRecvMsg();

private:
    void setupTrayIcon();

private:
    QList<QProcess*> m_children;
};

#endif // MAINWINDOW_H
