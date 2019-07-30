#ifndef CXQUICKPLUGIN_H
#define CXQUICKPLUGIN_H

#include "cxquick_global.h"
#include <QQmlExtensionPlugin>

class CXQUICK_SHARED_EXPORT CxQuickPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "Cx.CxFramework.CxQuick.Plugin")
public:
    void registerTypes(const char *uri) override;

signals:

public slots:
};

#endif // CXQUICKPLUGIN_H
