#include "localstorage.h"
#include <QCoreApplication>
#include <QDir>

#include <QDebug>

LocalStorage *LocalStorage::mOnly{nullptr};

struct LocalStorageData {
    QDir localStorageDir;

    LocalStorageData()
        : localStorageDir(qApp->applicationDirPath())
    {
        const QString relativeLocalDB{"../common/localdb"};
        if (!localStorageDir.cd(relativeLocalDB)) {
            localStorageDir.mkdir(relativeLocalDB);
            localStorageDir.cd(relativeLocalDB);
        }
    }
};

LocalStorage::LocalStorage(QObject *parent)
    : QObject(parent)
    , d(new LocalStorageData)
{
    qDebug() << "Construct LocalStorage";
}

LocalStorage::~LocalStorage()
{
    if (d) {
        delete d;
        d = nullptr;
    }

    qDebug() << "Drop LocalStorage";
}

LocalStorage &LocalStorage::instance()
{
    if (!mOnly) {
        mOnly = new LocalStorage();
    }
    return *mOnly;
}

void LocalStorage::drop()
{
    if (mOnly) {
        delete mOnly;
        mOnly = nullptr;
    }
}
