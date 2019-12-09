#ifndef CXFWDEMO_GLOBAL_H
#define CXFWDEMO_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(CXFWDEMO_LIBRARY)
#  define CXFWDEMO_EXPORT Q_DECL_EXPORT
#else
#  define CXFWDEMO_EXPORT Q_DECL_IMPORT
#endif

#endif // CXFWDEMO_GLOBAL_H
