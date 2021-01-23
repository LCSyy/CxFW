#ifndef CXQMLSETTINGS_HPP
#define CXQMLSETTINGS_HPP

#include <CxCore/cxsettings.h>
#include <QQmlEngine>

class CxQmlSettings : public CxSettings
{
    Q_OBJECT
    QML_ELEMENT
public:
    CxQmlSettings(QObject *parent = nullptr);
};

#endif // CXQMLSETTINGS_HPP
