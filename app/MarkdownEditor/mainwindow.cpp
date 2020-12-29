#include "mainwindow.h"
#include <QTextEdit>
#include "markdownsyntaxhighlighter.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    initUI();
    resize(800,600);
}

MainWindow::~MainWindow()
{
}

void MainWindow::initUI()
{
    m_textEditor = new QTextEdit(this);
    setCentralWidget(m_textEditor);
    m_highlighter = new MarkdownSyntaxHighlighter(m_textEditor);
}

