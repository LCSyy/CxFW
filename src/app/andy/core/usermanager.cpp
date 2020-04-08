#include "usermanager.h"
#include "localstorage.h"
#include <QEvent>
#include <QDebug>

UserManager *UserManager::only {nullptr};

struct UserManagerData {
    QString currentAccount;
};

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
UserManager::UserManager(QObject *parent)
    : QObject(parent)
    , d(new UserManagerData)
{

}

UserManager::~UserManager()
{
    if (d) {
        delete d;
        d = nullptr;
    }
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
    Q_UNUSED(account)
    Q_UNUSED(password)

    const QString sql = QString("SELECT COUNT(1) as count FROM sys_users WHERE account = '%1'").arg(account);
    const QVariantMap row = LocalStorage::self().loadData(sql,QStringList{}).value(0).toMap();
    if (row.value("count").toInt() != 1) {
        return false;
    }

    return true;
}

bool UserManager::signUp(const QString &account, const QString &password)
{
    // auth has account
    // save
    return false;
}

void UserManager::signOut(const QString &account)
{

}

bool UserManager::event(QEvent *ev)
{
    if (ev->type() == QEvent::User + 1) {
        return true;
    }
    return QObject::event(ev);
}
