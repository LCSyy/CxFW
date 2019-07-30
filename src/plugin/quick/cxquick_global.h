#ifndef CXQUICK_GLOBAL_H
#define CXQUICK_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(CXQUICK_SHARED_LIBRARY)
#  define CXQUICK_SHARED_EXPORT Q_DECL_EXPORT
#else
#  define CXQUICK_SHARED_EXPORT Q_DECL_IMPORT
#endif

#endif // CXQUICK_GLOBAL_H
