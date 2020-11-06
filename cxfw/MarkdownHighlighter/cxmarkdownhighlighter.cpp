#include "cxmarkdownhighlighter.h"
#include <QDebug>

CxMarkdownHighlighter::CxMarkdownHighlighter(QObject *parent)
    : QSyntaxHighlighter(parent)
{

}

CxMarkdownHighlighter::CxMarkdownHighlighter(QTextDocument *doc)
    : QSyntaxHighlighter(doc)
{

}

CxMarkdownHighlighter::~CxMarkdownHighlighter()
{

}

void CxMarkdownHighlighter::highlightBlock(const QString &text)
{
    QTextCharFormat fmt;

    if (text.startsWith("###")) {
        fmt.setFontPointSize(15);
    } else if (text.startsWith("##")) {
        fmt.setFontPointSize(20);
    } else if (text.startsWith("#")) {
        fmt.setFontPointSize(25);
    }
    setFormat(0,text.length(),fmt);
}
