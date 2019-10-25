#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
class QStackedWidget;
class QTabWidget;
class QLabel;
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:
    void setCurrentPage(int idx);

private:
    QStackedWidget *mPage {nullptr};
    QLabel *mCurLabel {nullptr};
    QTabWidget *mTabWgt {nullptr};
};

#endif // MAINWINDOW_H
