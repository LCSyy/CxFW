#ifndef SYNTAXHIGHLIGHTER_H
#define SYNTAXHIGHLIGHTER_H

#include <QSyntaxHighlighter>

QT_BEGIN_NAMESPACE
class QQuickTextDocument;
class QBasicTimer;
QT_END_NAMESPACE

class QQuickTextDocument;
class SyntaxHighlighter : public QSyntaxHighlighter
{
    Q_OBJECT
    Q_PROPERTY(QQuickTextDocument* document READ doc WRITE setDoc NOTIFY docChanged)
public:
    explicit SyntaxHighlighter(QObject *parent = nullptr);
    explicit SyntaxHighlighter(QTextDocument *parent);
    ~SyntaxHighlighter();

    Q_INVOKABLE void setDoc(QQuickTextDocument *doc);
    Q_INVOKABLE QQuickTextDocument *doc() const;

protected:
    void timerEvent(QTimerEvent *ev) override;
    void highlightBlock(const QString &text) override;

private:
    void formatHead(const QString &text);

signals:
    void docChanged(QPrivateSignal);

private:
    QBasicTimer *m_timer{nullptr};
    QQuickTextDocument *m_doc{nullptr};
    QList<QTextBlock> m_blocks;
};

#endif // SYNTAXHIGHLIGHTER_H
