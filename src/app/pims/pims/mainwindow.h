#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
class QTextEdit;
QT_END_NAMESPACE

class LocalDB: public QObject
{
    Q_OBJECT
public:
    explicit LocalDB(QObject *parent);
    ~LocalDB();

private:
    void initPIMS();
    void initNoteModule();
};

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void onSave();
    void loadContent();

private:
    QTextEdit *mTextEdit {nullptr};
    LocalDB *mLocalDB {nullptr};
};

#endif // MAINWINDOW_H
