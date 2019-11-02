#ifndef NAVIWIDGET_H
#define NAVIWIDGET_H

#include <QWidget>
#include <QIcon>

class NaviWidget : public QWidget
{
    Q_OBJECT
public:
    explicit NaviWidget(QWidget *parent = nullptr);

    void setIcon(const QIcon &icon);
    QIcon icon() const;
    void setText(const QString &text);
    QString text() const;

private:
    QIcon mIcon;
    QString mText;
};

#endif // NAVIWIDGET_H
