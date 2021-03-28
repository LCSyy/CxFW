#include "cxquickplugin.h"
#include <QQmlEngine>
#include <CxCore/cxlistmodel.h>
#include <CxCore/cxsettings.h>
#include <CxCore/cxurls.h>

#include "cxquick.h"
#include "cxnetwork.h"

namespace {

static QJSValue cxquickSingleton(QQmlEngine *qml, QJSEngine *js) {
    Q_UNUSED(qml)
    CxQuick *obj = new CxQuick(js);
    return js->newQObject(obj);
}

static QJSValue settingsSingleton(QQmlEngine *e, QJSEngine *s) {
    Q_UNUSED(e)
    return s->newQObject(new CxSettings(s));
}

static QJSValue networkSingleton(QQmlEngine *e, QJSEngine *s) {
    Q_UNUSED(e)
    return s->newQObject(new CxNetwork(s));
}

}

CxQuickPlugin::CxQuickPlugin(QObject *parent)
    : QQmlExtensionPlugin(parent)
{

}

CxQuickPlugin::~CxQuickPlugin()
{

}

void CxQuickPlugin::registerTypes(const char *uri)
{
    qmlRegisterSingletonType(uri, 0, 1, "CxQuick", cxquickSingleton);
    qmlRegisterSingletonType(uri, 0, 1, "CxSettings", settingsSingleton);
    qmlRegisterSingletonType(uri, 0, 1, "CxNetwork", networkSingleton);

    qmlRegisterType<CxListModel>(uri, 0, 1, "CxListModel");
}
