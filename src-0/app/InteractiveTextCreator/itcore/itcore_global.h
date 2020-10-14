#ifndef ITCORE_GLOBAL_H
#define ITCORE_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(ITCORE_LIBRARY)
#  define ITCORE_EXPORT Q_DECL_EXPORT
#else
#  define ITCORE_EXPORT Q_DECL_IMPORT
#endif

#endif // ITCORE_GLOBAL_H
