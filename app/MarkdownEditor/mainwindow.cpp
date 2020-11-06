#include "mainwindow.h"
#include <QTextEdit>
#include "MarkdownHightlighter/cxmarkdownhighlighter.h"

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

    m_syntaxHighlighter = new CxMarkdownHighlighter(m_textEditor->document());
}

