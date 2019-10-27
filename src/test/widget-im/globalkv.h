#ifndef GLOBALKV_H
#define GLOBALKV_H

#include <QObject>
#include <QVariantMap>

class GlobalKV : public QObject
{
    Q_OBJECT
public:
    static GlobalKV *instance();
    static void destroy();

public slots:
    void set(const QString &key, const QVariant &val);
    QVariant value(const QString &key) const;

private:
    explicit GlobalKV(QObject *parent = nullptr);
    Q_DISABLE_COPY_MOVE(GlobalKV)

    QVariantMap mDataMap;
};

#define pGlobalKV GlobalKV::instance()

#endif // GLOBALKV_H
