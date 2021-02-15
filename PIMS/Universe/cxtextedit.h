#ifndef CXTEXTEDIT_H
#define CXTEXTEDIT_H

#include <QTextEdit>

class CxTextEdit : public QTextEdit
{
    Q_OBJECT
public:
    explicit CxTextEdit(QWidget *parent = nullptr);

    QSize sizeHint() const override;

protected:
    void resizeEvent(QResizeEvent *ev) override;

private:
    void onTextChanged();

};

#endif // CXTEXTEDIT_H
