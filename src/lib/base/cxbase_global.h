#ifndef CXBASE_GLOBAL_H
#define CXBASE_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(CXBASE_LIBRARY)
#  define CXBASESHARED_EXPORT Q_DECL_EXPORT
#else
#  define CXBASESHARED_EXPORT Q_DECL_IMPORT
#endif

#endif // CXBASE_GLOBAL_H
