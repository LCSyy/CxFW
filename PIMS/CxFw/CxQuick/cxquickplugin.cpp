#include "cxquickplugin.h"
#include <QQmlEngine>
#include "theme.h"
#include <CxCore/cxlistmodel.h>
#include <CxNetwork/cxnetwork.h>
#include <MarkdownSyntaxHighlighter/cxquicksyntaxhighlighter.h>
#include <QGlobalShortcut/qglobalshortcut.h>

namespace {
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

CxQuickPlugin::CxQuickPlugin(QObject *parent)
    : QQmlExtensionPlugin(parent)
{

}

void CxQuickPlugin::registerTypes(const char *uri)
{
    qmlRegisterSingletonType(uri, 0, 1, "Theme", themeSingleton);
    qmlRegisterSingletonType(uri, 0, 1, "Network", networkSingleton);

    qmlRegisterType<CxListModel>(uri, 0,1, "ListModel");
    qmlRegisterType<CxQuickSyntaxHighlighter>(uri, 0,1, "SyntaxHighlighter");
    qmlRegisterType<QGlobalShortcut>(uri, 0,1, "GlobalShortcut");
}
