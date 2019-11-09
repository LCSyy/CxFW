#ifndef CHATVIEW_H
#define CHATVIEW_H

#include <QWidget>

class ChatView : public QWidget
{
    Q_OBJECT
public:
    explicit ChatView(QWidget *parent = nullptr);

protected:
    void paintEvent(QPaintEvent *event) override;
};

#endif // CHATVIEW_H
