#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
class QToolBar;
class QSplitter;
class QTabWidget;
class QStackedWidget;
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

    static MainWindow *self();

    QToolBar *toolBar() const;
    QSplitter *splitter() const;
    QTabWidget *tabWidget() const;
    QStackedWidget *stackedWidget() const;

    QWidget *findNavi(const QUrl &url) const;
    void addNavi(QWidget *wgt);
    void setNavi(const QUrl &url);
    void expandNavi(bool expand = true);
    bool naviExpanded() const;


    QWidget *findPage(const QUrl &url) const;
    void addPage(QWidget *wgt);
    void setPage(const QUrl &url);

private:
    QToolBar *mToolBar {nullptr};
    QSplitter *mSplitter {nullptr};
    QTabWidget *mTabWgt {nullptr};
    QStackedWidget *mStackedWgt {nullptr};
};

#endif // MAINWINDOW_H
