#include "cxtextedit.h"
#include <QDebug>

CxTextEdit::CxTextEdit(QWidget *parent)
    : QTextEdit(parent)
{
    setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Maximum);
    setHorizontalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    // setVerticalScrollBarPolicy(Qt::ScrollBarAlwaysOff);
    setWordWrapMode(QTextOption::WrapAnywhere);
    setMaximumHeight(26);
    setMinimumHeight(25);

    connect(this, &CxTextEdit::textChanged, this, &CxTextEdit::onTextChanged);
}

QSize CxTextEdit::sizeHint() const
{
    return QSize(minimumWidth(), minimumHeight());
}

void CxTextEdit::resizeEvent(QResizeEvent *ev)
{
    QTextEdit::resizeEvent(ev);
}

void CxTextEdit::onTextChanged()
{
    const int h = document()->size().height();
    if (h <= 100) {
        setMaximumHeight(document()->size().height());
    }
}
