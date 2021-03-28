#ifndef CXQUICKPLUGIN_H
#define CXQUICKPLUGIN_H

#include <QQmlExtensionPlugin>

class CxQuickPlugin: public QQmlExtensionPlugin {
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(CxQuickPlugin)
    Q_PLUGIN_METADATA(IID "org.cxfw.CxQuickPlugin")
public:
    explicit CxQuickPlugin(QObject *parent = nullptr);
    ~CxQuickPlugin() override;

    void registerTypes(const char *uri) override;
};

#endif
