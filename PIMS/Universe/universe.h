#ifndef UNIVERSE_H
#define UNIVERSE_H

#include <QObject>
#include <QVariantMap>

class Universe : public QObject
{
    Q_OBJECT
public:
    explicit Universe(QObject *parent = nullptr);

    enum NotifyReason {
        // 0 - 4 is trayicon active reason
        GlobalShorcut = 5,
        ActiveByRun,
    };

    Q_INVOKABLE void setData(const QString &key, const QVariant &data);
    Q_INVOKABLE QVariant getData(const QString &key) const;

    Q_INVOKABLE QString fileName(const QUrl &url) const;

signals:
    void notify(int reason);

private:
    QVariantMap m_datas;
};

#endif // UNIVERSE_H
