#ifndef QUICK_GLOBAL_H
#define QUICK_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(QUICK_LIBRARY)
#  define QUICK_EXPORT Q_DECL_EXPORT
#else
#  define QUICK_EXPORT Q_DECL_IMPORT
#endif

#endif // QUICK_GLOBAL_H
