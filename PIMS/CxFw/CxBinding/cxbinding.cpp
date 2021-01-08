#include "cxbinding.h"
#include <QQmlEngine>

#include <CxNetwork/cxnetwork.h>
#include <MarkdownSyntaxHighlighter/cxquicksyntaxhighlighter.h>
#include <QGlobalShortcut/qglobalshortcut.h>

namespace {
    constexpr char CXQUICK[] = "CxQuick";

    static QJSValue networkSingleton(QQmlEngine *e, QJSEngine *s) {
        Q_UNUSED(e)
        return s->newQObject(new CxNetwork(s));
    }
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
    qmlRegisterSingletonType(moduleName(),majorVersion(),minorVersion(),"Network",networkSingleton);
//    qmlRegisterSingletonType(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"Theme",themeSingleton);
}

void CxBinding::registerTypes()
{
//    qmlRegisterType<ListModel>(CXQUICK,CXQUICK_VERSION_MARJOR,CXQUICK_VERSION_MINOR,"ListModel");
    qmlRegisterType<CxQuickSyntaxHighlighter>(moduleName(),majorVersion(),minorVersion(),"SyntaxHighlighter");
    qmlRegisterType<QGlobalShortcut>(moduleName(),majorVersion(),minorVersion(),"GlobalShortcut");
}
