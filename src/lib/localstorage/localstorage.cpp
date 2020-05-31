#include "localstorage.h"
#include <QSqlDatabase>

LocalStorage::LocalStorage(const QString &path)
{
    QDir dir(path);
    Q_ASSERT(dir.exists());

    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(dir.absolutePath());
}
