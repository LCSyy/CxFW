#ifndef CXSTYLEPLUGIN_H
#define CXSTYLEPLUGIN_H

#include <QQmlExtensionPlugin>

class CxStylePlugin: public QQmlExtensionPlugin {
    Q_OBJECT
    Q_DISABLE_COPY_MOVE(CxStylePlugin)
    Q_PLUGIN_METADATA(IID "org.cxfw.CxStylePlugin")
public:
    CxStylePlugin(QObject *parent = nullptr);
    ~CxStylePlugin() override;

    void registerTypes(const char *uri) override;
};

#endif // CXSTYLEPLUGIN_H
