#include "backend.h"
#include <andy-core/usermanager.h>

Backend::Backend(QObject *parent) : QObject(parent)
{

}

bool Backend::signIn(const QString &account, const QString &passwd)
{
    return UserManager::self().signIn(account,passwd);
}

bool Backend::signUp(const QString &account, const QString &passwd)
{
    return UserManager::self().signUp(account,passwd);
}
