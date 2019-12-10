#include "cxfw.h"
#include <QDebug>

CxFW::CxFW()
{
}

void CxFW::sayHi() const
{
    qDebug() << "Hello";
}
