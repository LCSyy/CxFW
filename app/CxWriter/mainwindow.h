#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
class QToolButton;
class QFileSystemWatcher;
class QListView;
class QItemSelection;
QT_END_NAMESPACE

class CxStatusBar;
class CxBufferListModel;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void openFile(const QString &fileName);
    void updateWindowTitle();
    void setCurrent(const QItemSelection &selected, const QItemSelection &deselected);
    void switchNavi(bool expand = true);

    void onDocumentModificationChanged(bool changed);

    void on_actionOpenFile_triggered();
    void on_actionSave_triggered();
    void on_actionNewFile_triggered();

    void on_actionClose_triggered();

    void on_actionSwitchNavi_triggered();

protected:
    bool eventFilter(QObject *obj, QEvent *ev) override;

private:
    void initUI();
    void initStatusBar(CxStatusBar *statusbar);
    void reflectScrollBar();

private:
    Ui::MainWindow *ui;
    QToolButton *m_sideBarButton;
    CxStatusBar *m_statusBar;
    CxBufferListModel *m_listModel;
};

#endif // MAINWINDOW_H
