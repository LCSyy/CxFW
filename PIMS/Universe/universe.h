#ifndef UNIVERSE_H
#define UNIVERSE_H

#include <QObject>

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

signals:
    void notify(int reason);
};

#endif // UNIVERSE_H
