#ifndef MARKDOWNSYNTAXHIGHLIGHTER_H
#define MARKDOWNSYNTAXHIGHLIGHTER_H

#include <QSyntaxHighlighter>

class MarkdownSyntaxHighlighter: public QSyntaxHighlighter
{
    Q_OBJECT
public:
    MarkdownSyntaxHighlighter(QTextDocument *parent);
    MarkdownSyntaxHighlighter(QObject *parent);
    ~MarkdownSyntaxHighlighter();

protected:
    void highlightBlock(const QString &text) override;
};

#endif // MARKDOWNSYNTAXHIGHLIGHTER_H
