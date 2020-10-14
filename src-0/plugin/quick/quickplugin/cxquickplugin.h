#ifndef CXQUICKPLUGIN_H
#define CXQUICKPLUGIN_H

#include <QQmlExtensionPlugin>

class CxQuickPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "me.lcs.QGenericPluginFactoryInterface")

public:
    explicit CxQuickPlugin(QObject *parent = nullptr);

    void registerTypes(const char *uri) override;
};

#endif // CXQUICKPLUGIN_H
