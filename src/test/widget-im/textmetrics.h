#ifndef TEXTMETRICS_H
#define TEXTMETRICS_H

#include <QObject>

#include <QFontMetrics>

class TextMetrics : public QObject
{
    Q_OBJECT
public:
    explicit TextMetrics(QObject *parent = nullptr);

    Q_INVOKABLE QRect boundingRect(const QRect &rect, const QString &text) const;

private:
    QFontMetrics mMetrics;
};

#endif // TEXTMETRICS_H
