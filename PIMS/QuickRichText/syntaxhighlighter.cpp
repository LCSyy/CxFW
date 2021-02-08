#include "syntaxhighlighter.h"
#include <QBasicTimer>
#include <QTimerEvent>
#include <QRegularExpression>
#include <QQuickTextDocument>
#include <QGuiApplication>
#include <QFont>
#include "syntaxdefinitions.h"
#include <QDebug>

SyntaxHighlighter::SyntaxHighlighter(QObject *parent)
    : QSyntaxHighlighter(parent)
    , m_timer(new QBasicTimer())
{

}

SyntaxHighlighter::SyntaxHighlighter(QTextDocument *parent)
    : QSyntaxHighlighter(parent)
{

}

SyntaxHighlighter::~SyntaxHighlighter()
{
    m_timer->stop();
    delete m_timer;
}

void SyntaxHighlighter::setDoc(QQuickTextDocument *doc)
{
    if (m_doc == doc) {
        setDocument(nullptr);
        return;
    }

    m_doc = doc;

    setDocument(m_doc->textDocument());

    emit docChanged(QPrivateSignal{});
}

QQuickTextDocument *SyntaxHighlighter::doc() const
{
    return m_doc;
}

void SyntaxHighlighter::timerEvent(QTimerEvent *ev)
{
    if (ev->timerId() == m_timer->timerId()) {
        while (!m_blocks.isEmpty()) {
            QTextBlock b = m_blocks.takeFirst();
            if (b.isValid()) {
                rehighlightBlock(b);
            }
        }
        return;
    }

    QSyntaxHighlighter::timerEvent(ev);
}

// text to html
void SyntaxHighlighter::highlightBlock(const QString &text)
{
    qDebug() << "block text: " << text;
    // QRegularExpression regex;

    // parseToken();

    //

    if (text.startsWith(md::Head)) {
        formatHead(text);
    }
}

void SyntaxHighlighter::formatHead(const QString &text)
{
    QTextCharFormat format;

    QFont f;
    f.setBold(true);

    if (text.startsWith(md::Head6)) {
        f.setPointSize(qGuiApp->font().pointSize());
    } else if (text.startsWith(md::Head5)) {
        f.setPointSize(qGuiApp->font().pointSize() + 2);
    } else if (text.startsWith(md::Head4)) {
        f.setPointSize(qGuiApp->font().pointSize() + 4);
    } else if (text.startsWith(md::Head2)) {
        f.setPointSize(qGuiApp->font().pointSize() + 6);
    } else if (text.startsWith(md::Head2)) {
        f.setPointSize(qGuiApp->font().pointSize() + 8);
    } else if (text.startsWith(md::Head1)) {
        f.setPointSize(qGuiApp->font().pointSize() + 10);
    }

    format.setFont(f);
    setFormat(0,text.length(),format);
}
