#ifndef UTILITY_H
#define UTILITY_H

#include <QObject>
#include <QSize>

QT_BEGIN_NAMESPACE
class QFontMetrics;
QT_END_NAMESPACE

class Utility : public QObject
{
    Q_OBJECT
public:
    explicit Utility(QObject *parent = nullptr);

    Q_INVOKABLE int textLineCount(const QString &text) const;
};

#endif // UTILITY_H
