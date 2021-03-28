#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Qt3DCore {
    class QEntity;
}
namespace Qt3DRender {
    class QPickEvent;
};
namespace Qt3DExtras {
    class Qt3DWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

    Qt3DCore::QEntity *addCube(Qt3DCore::QEntity *parent);

private slots:
    void onPick(Qt3DRender::QPickEvent *ev);

private:
    void init3DScene();

private:
    Qt3DExtras::Qt3DWindow *m_view;
    Qt3DCore::QEntity *m_root;
};
#endif // MAINWINDOW_H
