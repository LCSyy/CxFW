#include "markdownsyntaxhighlighter.h"

MarkdownSyntaxHighlighter::MarkdownSyntaxHighlighter(QTextDocument *parent)
    : QSyntaxHighlighter(parent)
{

}

MarkdownSyntaxHighlighter::MarkdownSyntaxHighlighter(QObject *parent)
    : QSyntaxHighlighter(parent)
{

}

MarkdownSyntaxHighlighter::~MarkdownSyntaxHighlighter()
{

}

void MarkdownSyntaxHighlighter::highlightBlock(const QString &text)
{

}
