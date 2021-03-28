#include "cxstyleplugin.h"
#include <QQmlContext>
#include <QQmlEngine>
#include <QDebug>

#include "cxstyle.h"

namespace {

QJSValue cxStyleSingleton(QQmlEngine *qml, QJSEngine *js) {
    Q_UNUSED(qml)
    CxStyle *obj = new CxStyle(js);
    return js->newQObject(obj);
}

}

CxStylePlugin::CxStylePlugin(QObject *parent)
    : QQmlExtensionPlugin(parent)
{

}

CxStylePlugin::~CxStylePlugin()
{

}

void CxStylePlugin::registerTypes(const char *uri)
{
    qmlRegisterSingletonType(uri, 0, 1, "CxStyle", cxStyleSingleton);
}
