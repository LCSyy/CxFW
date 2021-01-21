#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QSystemTrayIcon>

QT_BEGIN_NAMESPACE
class QProcess;
class QQuickWidget;
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

    void setupTrayIcon(const QIcon &icon);

private slots:
    void onTrayIconActivated(QSystemTrayIcon::ActivationReason reason);

private:
    QQuickWidget *m_view {nullptr};
};

#endif // MAINWINDOW_H
