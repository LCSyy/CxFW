#ifndef CXQUICKPLUGIN_H
#define CXQUICKPLUGIN_H

#include <QGenericPlugin>

class CxQuickPlugin : public QGenericPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QGenericPluginFactoryInterface" FILE "quickplugin.json")

public:
    explicit CxQuickPlugin(QObject *parent = nullptr);

private:
    QObject *create(const QString &name, const QString &spec) override;
};

#endif // CXQUICKPLUGIN_H
