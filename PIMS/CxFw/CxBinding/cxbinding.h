#ifndef CXBINDING_H
#define CXBINDING_H

#include <QString>

class CxBinding
{
public:
    CxBinding();

    static const char *moduleName();
    static int majorVersion();
    static int minorVersion();

    static void registerAll();

    static void registerSingletonInstance();
    static void registerSingletonTypes();
    static void registerTypes();
};

#endif // CXBINDING_H
