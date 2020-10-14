#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

namespace widget_ui {
struct Ui;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = 0);
    ~MainWindow();

private:
    widget_ui::Ui* ui {nullptr};
};

#endif // MAINWINDOW_H
