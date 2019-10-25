#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
class QToolBar;
class QStackedWidget;
class QTabBar;
class QLabel;
class QSplitter;
QT_END_NAMESPACE
class NaviWidget;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:
    void addNavi(NaviWidget *navi, const QUrl &naviUrl);
    void collapseNavi(bool collpase = true);
    void openPage(const QUrl &tabPageUrl);

private slots:
    void onNaviActionTriggered(bool checked);

private:
    QSplitter *mSplitter {nullptr};
    QToolBar *mToolBar {nullptr};
    QStackedWidget *mNaviDock {nullptr};
    QLabel *mCurLabel {nullptr};
    QTabBar *mTabBar {nullptr};
};

#endif // MAINWINDOW_H
