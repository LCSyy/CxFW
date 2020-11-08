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

    void onDocumentModificationChanged(bool changed);

    void on_actionOpenFile_triggered();
    void on_actionSave_triggered();
    void on_actionNewFile_triggered();

    void on_actionClose_triggered();

protected:
    bool eventFilter(QObject *obj, QEvent *ev) override;

private:
    void initUI();
    void initStatusBar(QStatusBar *statusbar);
    void reflectScrollBar();

private:
    Ui::MainWindow *ui;
    QToolButton *m_sideBarButton;
    CxBufferListModel *m_listModel;
};

#endif // MAINWINDOW_H
