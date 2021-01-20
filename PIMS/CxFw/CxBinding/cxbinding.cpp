#include "cxbinding.h"
#include <QQmlEngine>

#include <CxNetwork/cxnetwork.h>
#include <MarkdownSyntaxHighlighter/cxquicksyntaxhighlighter.h>
#include <QGlobalShortcut/qglobalshortcut.h>
#include <CxCore/cxlistmodel.h>

namespace {
    constexpr char CXQUICK[] = "CxQuick";
}

CxBinding::CxBinding()
{

}

const char *CxBinding::moduleName()
{
    return CXQUICK;
}

int CxBinding::majorVersion()
{
    return 0;
}

int CxBinding::minorVersion()
{
    return 1;
}

void CxBinding::registerAll()
{
    registerSingletonInstance();
    registerSingletonTypes();
    registerTypes();
}

void CxBinding::registerSingletonInstance()
{
    // qmlRegisterSingletonInstance(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"App",this);
}

void CxBinding::registerSingletonTypes()
{
}

void CxBinding::registerTypes()
{
}
