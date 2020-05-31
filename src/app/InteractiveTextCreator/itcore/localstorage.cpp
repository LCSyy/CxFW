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

void LocalStorage::loadData(const QString &sql)
{
    QSqlQuery query(QSqlDatabase::database());
    if (!query.exec(sql)) {
        qDebug() << query.lastError().text();
        return;
    }

    while (query.next()) {
        QSqlRecord record = query.record();
        for (int i = 0; i < record.count(); ++i) {
            QSqlField field = record.field(i);
            qDebug() << field.name() << ":" << field.value();
        }
        qDebug() << "---------";
    }
}

LocalStorage::LocalStorage()
{
    QDir dir("../common/localdb/");
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
