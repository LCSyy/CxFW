#ifndef SYSTEMMANAGER_H
#define SYSTEMMANAGER_H

#include <QObject>

struct SystemManagerData;
class SystemManager : public QObject
{
    Q_OBJECT
public:

    static SystemManager *instance();
    static SystemManager &self();
    static void drop();

    void initSystem();

protected:
    explicit SystemManager(QObject *parent = nullptr);
    ~SystemManager();
    Q_DISABLE_COPY(SystemManager)

    static SystemManager *only;

private:
    SystemManagerData *d {nullptr};
};

#endif // SYSTEMMANAGER_H
