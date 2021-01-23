#ifndef CXSETTINGS_H
#define CXSETTINGS_H

#include <QSettings>

class CxSettings : public QSettings
{
    Q_OBJECT
public:
    explicit CxSettings(QObject *parent = nullptr);

    Q_INVOKABLE QVariant get(const QString &key) const;
    Q_INVOKABLE void beginReadArray(const QString &prefix);
    Q_INVOKABLE void beginWriteArray(const QString &prefix);
    Q_INVOKABLE void setArrayIndex(int i);
    Q_INVOKABLE void endArray();
public slots:
    void set(const QString &key, const QVariant &val=QVariant{});
};

#endif // CXSETTINGS_H
