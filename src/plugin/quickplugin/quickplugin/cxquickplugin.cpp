#include "cxquickplugin.h"
#include <QDebug>

CxQuickPlugin::CxQuickPlugin(QObject *parent)
    : QGenericPlugin(parent)
{
}

QObject *CxQuickPlugin::create(const QString &name, const QString &spec)
{
    if(name == "cxquick" && spec == "noitem") {
        return nullptr;
    }
    return nullptr;
}
