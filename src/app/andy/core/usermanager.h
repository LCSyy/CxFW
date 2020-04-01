#ifndef USERMANAGER_H
#define USERMANAGER_H

#include <QObject>

class UserManager : public QObject
{
    Q_OBJECT
public:

    static UserManager *instance();
    static UserManager &self();
    static void drop();

    bool signIn(const QString &account, const QString &password);
    bool signUp(const QString &account, const QString &password);
    void signOut(const QString &account);

protected:
    explicit UserManager(QObject *parent = nullptr);
    ~UserManager();
    Q_DISABLE_COPY(UserManager)

    static UserManager *only;
};

#endif // USERMANAGER_H
