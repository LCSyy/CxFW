#ifndef USERMANAGER_H
#define USERMANAGER_H

#include <QObject>

class UserManager : public QObject
{
    Q_OBJECT
public:
    explicit UserManager(QObject *parent = nullptr);

    bool signIn(const QString &account, const QString &password);
    bool signUp(const QString &account, const QString &password);
    void signOut(const QString &account);
};

#endif // USERMANAGER_H
