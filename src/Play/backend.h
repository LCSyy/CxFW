#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QQmlEngine>

class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int major MEMBER mMajor NOTIFY majorChanged)
    Q_PROPERTY(int minor MEMBER mMinor NOTIFY minorChanged REVISION 1)
signals:
    void majorChanged(int major);
    void minorChanged(int minor);

public:
    explicit Backend(QObject *parent = nullptr);

protected:
    int mMajor{0};
    int mMinor{1};
};

#endif // BACKEND_H
