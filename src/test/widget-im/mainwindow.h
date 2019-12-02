#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
class QTextBrowser;
class QLineEdit;
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = nullptr);

private slots:
    void onSendMessage();

private:
    QTextBrowser *mTextBrowser {nullptr};
    QLineEdit *mInputField {nullptr};
};

#endif // MAINWINDOW_H
