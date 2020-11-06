#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
class QTextEdit;
QT_END_NAMESPACE

class CxMarkdownHighlighter;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private:
    void initUI();

private:
    QTextEdit *m_textEditor;
    CxMarkdownHighlighter *m_syntaxHighlighter;
};
#endif // MAINWINDOW_H
