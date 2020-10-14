#include "localstorage.h"
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QDir>
#include <QSqlRecord>
#include <QSqlField>
#include <QSqlError>

#include <QDebug>

namespace  {
static LocalStorage *instance {nullptr};
constexpr char DEFAULT_LOCAL_DB_DIR[] = "../common/localdb/";
}

LocalStorage &LocalStorage::self()
{
    if (!instance) {
        instance = new LocalStorage;
    }
    return *instance;
}

void LocalStorage::drop()
{
    if (instance) {
        delete instance;
        instance = nullptr;
    }
}

QVariantList LocalStorage::loadData(const QString &sql)
{
    QVariantList dataLst;
    QSqlQuery query(QSqlDatabase::database());
    if (!query.exec(sql)) {
        qDebug() << query.lastError().text();
        return dataLst;
    }

    while (query.next()) {
        QVariantMap rowMap;
        QSqlRecord record = query.record();
        for (int i = 0; i < record.count(); ++i) {
            QSqlField field = record.field(i);
            rowMap.insert(field.name(),field.value());
        }
        dataLst.append(rowMap);
    }

    return dataLst;
}

LocalStorage::LocalStorage()
{
    QDir dir(DEFAULT_LOCAL_DB_DIR);
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dir.absoluteFilePath("story.db"));
    db.open();
}

LocalStorage::~LocalStorage()
{
    QString name;
    {
        QSqlDatabase db = QSqlDatabase::database();
        name = db.connectionName();
    }
    QSqlDatabase::removeDatabase(name);
}
