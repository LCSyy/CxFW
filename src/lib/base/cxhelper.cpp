#include "cxhelper.h"
#include <QDebug>

CxHelper::CxHelper()
{

}

void CxHelper::dbg(const QString &info)
{
#ifdef CX_DEBUG
    qDebug().nospace().noquote() << "[" << __LINE__ << "," << __FUNCTION__ << "]\t" << info;
#else
    Q_UNUSED(info)
#endif
}
