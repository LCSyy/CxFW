#ifndef MESSAGEEDITWIDGET_H
#define MESSAGEEDITWIDGET_H

#include <QWidget>

QT_BEGIN_NAMESPACE
class QTextEdit;
class QPushButton;
QT_END_NAMESPACE

class MessageEditWidget : public QWidget
{
    Q_OBJECT
signals:
    void sendMessage();
public:
    explicit MessageEditWidget(QWidget *parent = nullptr);

    QString message() const;

private:
    QTextEdit *mTextEdit {nullptr};
    QPushButton *mSendBtn {nullptr};
};

#endif // MESSAGEEDITWIDGET_H
