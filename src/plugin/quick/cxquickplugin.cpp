#include "cxquickplugin.h"
#include "cxcolorpicker.h"

#include <QDebug>

void CxQuickPlugin::registerTypes(const char *uri)
{
    qmlRegisterType<CxColorPicker>(uri,0,1,"CxColorPicker");
}
