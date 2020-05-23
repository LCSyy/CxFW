#ifndef UTIL_H
#define UTIL_H

#include <QObject>
#include <QFont>
#include <QRect>

class Util : public QObject
{
    Q_OBJECT
public:
    explicit Util(QObject *parent = nullptr);

    Q_INVOKABLE QRect textBoundingRect(const QRect &rect, int flags, const QString &text, const QFont &font) const;
};

#endif // UTIL_H
