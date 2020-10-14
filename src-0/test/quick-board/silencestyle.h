#ifndef SILENCESTYLE_H
#define SILENCESTYLE_H

#include <QObject>
#include <QColor>

class SilenceStyle : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QColor background READ background CONSTANT)
    Q_PROPERTY(QColor foreground READ foreground CONSTANT)
    Q_PROPERTY(QColor focusBackground READ focusBackground CONSTANT)
    Q_PROPERTY(QColor focusForeground READ focusForeground CONSTANT)
public:
    explicit SilenceStyle(QObject *parent = nullptr);

    QColor background() const { return QColor("#5f768d"); }
    QColor foreground() const { return QColor("#e5e5e5"); }

    QColor focusBackground() const { return QColor("#5f768d"); }
    QColor focusForeground() const { return QColor("#e5e5e5"); }

public slots:

};

#endif // SILENCESTYLE_H
