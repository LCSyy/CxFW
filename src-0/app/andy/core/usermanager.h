#ifndef USERMANAGER_H
#define USERMANAGER_H

#include "core_global.h"
#include <QObject>

struct UserManagerData;
class CORE_EXPORT UserManager : public QObject
{
    Q_OBJECT
public:

    static UserManager *instance();
    static UserManager &self();
    static void drop();

    bool signIn(const QString &account, const QString &password);
    bool signUp(const QString &account, const QString &password);
    void signOut(const QString &account);

    bool event(QEvent *ev) override;

protected:
    explicit UserManager(QObject *parent = nullptr);
    ~UserManager() override;
    Q_DISABLE_COPY(UserManager)

    static UserManager *only;

private:
    UserManagerData *d {nullptr};
};

#endif // USERMANAGER_H
