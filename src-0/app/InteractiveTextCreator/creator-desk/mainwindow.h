#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
class QTextEdit;
class QGraphicsView;
class QGraphicsScene;
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:
    void initUi();
    void initGraphicsView(QWidget *parent);

private:
    QTextEdit *textEdit;
    QGraphicsView *graphView;
    QGraphicsScene *graphScene;
};


#endif // MAINWINDOW_H
