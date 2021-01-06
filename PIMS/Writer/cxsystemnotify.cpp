#include "cxsystemnotify.h"

CxSystemNotify::CxSystemNotify(QObject *parent)
    : QObject(parent)
{

}

CxSystemNotify::~CxSystemNotify()
{

}

// do nothing yet.
void CxSystemNotify::onTrayActivated(QSystemTrayIcon::ActivationReason reason)
{
    switch(reason) {
    case QSystemTrayIcon::DoubleClick:
        break;
    default:
        ;
    }

    emit systemTrayIconActivated(reason, QPrivateSignal{});
}

