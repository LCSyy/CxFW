#include "cxbinding.h"
#include <QQmlEngine>

#include <CxNetwork/cxnetwork.h>
#include <MarkdownSyntaxHighlighter/cxquicksyntaxhighlighter.h>
#include <QGlobalShortcut/qglobalshortcut.h>
#include <CxQuick/theme.h>
#include <CxCore/cxlistmodel.h>

namespace {
    constexpr char CXQUICK[] = "CxQuick";

    static QJSValue networkSingleton(QQmlEngine *e, QJSEngine *s) {
        Q_UNUSED(e)
        return s->newQObject(new CxNetwork(s));
    }

    static QJSValue themeSingleton(QQmlEngine *e, QJSEngine *s)
    {
        Q_UNUSED(e)
        return s->newQObject(new Theme(s));
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
    qmlRegisterSingletonType(moduleName(),majorVersion(),minorVersion(),"Theme",themeSingleton);
}

void CxBinding::registerTypes()
{
    qmlRegisterType<CxListModel>(moduleName(),majorVersion(),minorVersion(),"ListModel");
    qmlRegisterType<CxQuickSyntaxHighlighter>(moduleName(),majorVersion(),minorVersion(),"SyntaxHighlighter");
    qmlRegisterType<QGlobalShortcut>(moduleName(),majorVersion(),minorVersion(),"GlobalShortcut");
}
