#ifndef LOCALSTORAGE_H
#define LOCALSTORAGE_H

#include "core_global.h"
#include <QObject>
#include <QVariantList>
#include <QVector>

struct LocalStorageData;
class CORE_EXPORT LocalStorage : public QObject
{
    Q_OBJECT
public:
    ~LocalStorage();

    static LocalStorage *instance();
    static LocalStorage &self();
    static void drop();

    QString localStorageFilePath() const;
    void initDatabase();
    void dropDatabase();

    QVariantList loadData(const QString& sql, const QStringList &fields);
    void createData(const QVariantMap &row);
    void removeData(const QString &id);
    void alterData(const QString &id, const QString &key, const QVariant &val);

protected:
    explicit LocalStorage(QObject *parent = nullptr);
    Q_DISABLE_COPY(LocalStorage)

    static LocalStorage *only;

private:
    LocalStorageData *d {nullptr};
};

#endif // LOCALSTORAGE_H
