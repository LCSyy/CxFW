#include "cxquickplugin.h"
#include <QQmlEngine>
#include <CxCore/cxlistmodel.h>
#include <CxCore/cxsettings.h>
#include <CxNetwork/cxnetwork.h>
#include <MarkdownSyntaxHighlighter/cxquicksyntaxhighlighter.h>
#include <QGlobalShortcut/qglobalshortcut.h>
#include "theme.h"
#include "cxqmlsettings.h"

namespace {

static QJSValue networkSingleton(QQmlEngine *e, QJSEngine *s) {
    Q_UNUSED(e)
    return s->newQObject(new CxNetwork(s));
}

static QJSValue themeSingleton(QQmlEngine *e, QJSEngine *s) {
    Q_UNUSED(e)
    return s->newQObject(new Theme(s));
}

static QJSValue settingsSingleton(QQmlEngine *e, QJSEngine *s) {
    Q_UNUSED(e)
    return s->newQObject(new CxSettings(s));
}

}

CxQuickPlugin::CxQuickPlugin(QObject *parent)
    : QQmlExtensionPlugin(parent)
{

}

void CxQuickPlugin::registerTypes(const char *uri)
{
    qmlRegisterSingletonType(uri, 0, 1, "CxTheme", themeSingleton);
    qmlRegisterSingletonType(uri, 0, 1, "CxNetwork", networkSingleton);
    qmlRegisterSingletonType(uri, 0, 1, "CxSettings", settingsSingleton);

    qmlRegisterType<CxListModel>(uri, 0,1, "CxListModel");
    qmlRegisterType<CxQuickSyntaxHighlighter>(uri, 0,1, "CxSyntaxHighlighter");
    qmlRegisterType<QGlobalShortcut>(uri, 0,1, "CxGlobalShortcut");
    // qmlRegisterType<CxQmlSettings>(uri, 0, 1, "CxSettings");
}
