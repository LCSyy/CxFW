#include "cxquicksyntaxhighlighter.h"
#include "MarkdownSyntaxHighlighter/markdownhighlighter.h"
#include <QQuickTextDocument>
#include <QDebug>

CxQuickSyntaxHighlighter::CxQuickSyntaxHighlighter(QObject *parent)
    : QObject(parent)
    , m_highlighter(new MarkdownHighlighter())
{
}

CxQuickSyntaxHighlighter::~CxQuickSyntaxHighlighter()
{
    if (m_highlighter) {
        delete m_highlighter;
    }
}

QQuickTextDocument *CxQuickSyntaxHighlighter::target()
{
    return m_doc;
}

void CxQuickSyntaxHighlighter::setTarget(QQuickTextDocument *doc)
{
    m_doc = doc;
    if (m_doc && m_doc->textDocument()) {
        m_highlighter->setDocument(m_doc->textDocument());
    }
}
