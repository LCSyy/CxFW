#include "cxquickplugin.h"
#include <QQmlEngine>
#include "canvas.h"

#include <QDebug>

CxQuickPlugin::CxQuickPlugin(QObject *parent)
    : QQmlExtensionPlugin(parent)
{
}

void CxQuickPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<Canvas>(uri,1,0,"Canvas");
}
