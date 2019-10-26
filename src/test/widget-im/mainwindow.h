#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
class QToolBar;
class QStackedWidget;
class QLabel;
class QSplitter;
class QAction;
QT_END_NAMESPACE
class NaviWidget;
class PageContainer;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

public slots:
    void addNavi(NaviWidget *navi, const QUrl &naviUrl);
    void removeNavi(const QUrl &naviUrl);
    void collapseNavi(bool collpase = true);
    void openPage(const QUrl &pageUrl);

private slots:
    void onSplitterMoved(int pos, int idx);
    void onNaviActionTriggered(bool checked);
    void onCurrentPageChanged(const QUrl &url);

private:
    QSplitter *mSplitter {nullptr};
    QToolBar *mToolBar {nullptr};
    QAction *mCustomSeperator{nullptr};
    QStackedWidget *mNaviDock {nullptr};
    QLabel *mCurLabel {nullptr};
    PageContainer *mPageContainer {nullptr};
};

#endif // MAINWINDOW_H
