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
    void sendMessage(const QString &msgBufferPath);

public:
    explicit MessageEditWidget(QWidget *parent = nullptr);

private slots:
    void onSendMsgClicked();

protected:
    void keyPressEvent(QKeyEvent *event) override;

private:
    QTextEdit *mTextEdit {nullptr};
    QPushButton *mSendBtn {nullptr};
};

#endif // MESSAGEEDITWIDGET_H
