#ifndef CXMARKDOWNHIGHLIGHTER_H
#define CXMARKDOWNHIGHLIGHTER_H

#include <QSyntaxHighlighter>

class CxMarkdownHighlighter: public QSyntaxHighlighter
{
    Q_OBJECT
public:
    explicit CxMarkdownHighlighter(QObject *parent);
    explicit CxMarkdownHighlighter(QTextDocument *doc);
    ~CxMarkdownHighlighter();

protected:
    void highlightBlock(const QString &text) override;

};

#endif

