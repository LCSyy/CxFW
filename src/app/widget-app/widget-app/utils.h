#ifndef UTILS_H
#define UTILS_H

#include <QObject>
#include <QVariantMap>

class Utils : public QObject
{
    Q_OBJECT
public:
    explicit Utils(QObject *parent = nullptr);

public slots:

    QVariantMap now() const;
    qint64 timeDurationSeconds(const QVariantMap &start, const QVariantMap &end) const;
    QString dateTime2Str(const QVariantMap &dt) const;
};

#endif // UTILS_H
