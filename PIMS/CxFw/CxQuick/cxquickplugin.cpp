#include "cxquickplugin.h"
#include <QQmlEngine>
#include "theme.h"
#include <CxCore/cxlistmodel.h>

namespace {
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
    qmlRegisterType<CxListModel>(uri, 0,1, "CxListModel");
}
