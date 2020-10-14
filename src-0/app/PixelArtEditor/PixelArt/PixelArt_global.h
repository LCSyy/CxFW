#ifndef PIXELART_GLOBAL_H
#define PIXELART_GLOBAL_H

#include <QtCore/qglobal.h>

#if defined(PIXELART_LIBRARY)
#  define PIXELART_EXPORT Q_DECL_EXPORT
#else
#  define PIXELART_EXPORT Q_DECL_IMPORT
#endif

#endif // PIXELART_GLOBAL_H
