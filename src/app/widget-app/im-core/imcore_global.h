#ifndef IMCORE_GLOBAL_H
#define IMCORE_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(IMCORE_LIBRARY)
#  define IMCORE_EXPORT Q_DECL_EXPORT
#else
#  define IMCORE_EXPORT Q_DECL_IMPORT
#endif

#endif // IMCORE_GLOBAL_H
