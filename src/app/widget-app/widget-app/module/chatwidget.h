#ifndef CHATWIDGET_H
#define CHATWIDGET_H

#include <QWidget>

QT_BEGIN_NAMESPACE
class QSplitter;
QT_END_NAMESPACE

class ChatWidget : public QWidget
{
    Q_OBJECT
public:
    explicit ChatWidget(QWidget *parent = nullptr);

private:
};

#endif // CHATWIDGET_H
