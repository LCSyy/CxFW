#include "usermanager.h"
#include "storagemanager.h"

UserManager *UserManager::only {nullptr};

/*! 用户管理
 * SignIn(account,password) {
 *   if hasUser(account):
 *     if passwordOk(account,password):
 *       signInOk()
 *     else:
 *       signInFail()
 *   else:
 *     noThisUser()
 * }
 *
 * SignUp()
 *   inputAccount()
 *     if alreadyHasAccount():
 *     else:
 *       inputPassword():
 *         if tooSimple():
 *         else:
 *           SignUpOk()
 *
 * SignOut
 */

/*!
 * \brief UserManager::UserManager
 * \param parent
 */
UserManager::UserManager(QObject *parent) : QObject(parent)
{

}

UserManager::~UserManager()
{

}

UserManager *UserManager::instance()
{
    if (!only) {
        only = new UserManager;
    }
    return only;
}

UserManager &UserManager::self()
{
    return *instance();
}

void UserManager::drop()
{
    if (only) {
        delete only;
        only = nullptr;
    }
}

bool UserManager::signIn(const QString &account, const QString &password)
{
    return false;
}

bool UserManager::signUp(const QString &account, const QString &password)
{
    return false;
}

void UserManager::signOut(const QString &account)
{

}
