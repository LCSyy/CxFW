#ifndef CXQUICKSYNTAXHIGHLIGHTER_H
#define CXQUICKSYNTAXHIGHLIGHTER_H

#include <QObject>

QT_BEGIN_NAMESPACE
class QQuickTextDocument;
QT_END_NAMESPACE
class MarkdownHighlighter;

class CxQuickSyntaxHighlighter : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QQuickTextDocument* target READ target WRITE setTarget)
public:
    explicit CxQuickSyntaxHighlighter(QObject *parent = nullptr);
    ~CxQuickSyntaxHighlighter();

    QQuickTextDocument *target();
    void setTarget(QQuickTextDocument *doc);

signals:

private:
    MarkdownHighlighter *m_highlighter;
    QQuickTextDocument *m_doc;
};

#endif // CXQUICKSYNTAXHIGHLIGHTER_H
