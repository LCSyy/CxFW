#include "usermanager.h"


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
