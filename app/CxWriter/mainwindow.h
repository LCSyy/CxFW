#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
class QToolButton;
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_actionOpenFile_triggered();

    void openFile(const QString &fileName);
    void appendFileToList(const QString &fileName);

protected:
    bool eventFilter(QObject *obj, QEvent *ev) override;

private:
    void initUI();
    void initStatusBar(QStatusBar *statusbar);
    void reflectScrollBar();

private:
    Ui::MainWindow *ui;
    QToolButton *m_sideBarButton;
};
#endif // MAINWINDOW_H
