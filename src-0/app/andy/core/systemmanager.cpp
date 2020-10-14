#include "systemmanager.h"
#include "localstorage.h"

SystemManager *SystemManager::only{nullptr};

struct SystemManagerData {

};

SystemManager::SystemManager(QObject *parent)
    : QObject(parent)
    , d(new SystemManagerData)
{

}

SystemManager::~SystemManager()
{
    if (d) {
        delete d;
        d = nullptr;
    }
}

SystemManager *SystemManager::instance()
{
    if (!only) {
        only = new SystemManager;
    }
    return only;
}

SystemManager &SystemManager::self()
{
    return *instance();
}

void SystemManager::drop()
{
    if (only) {
        delete only;
        only = nullptr;
    }
}

void SystemManager::initSystem()
{
    LocalStorage::self().initDatabase();
}
