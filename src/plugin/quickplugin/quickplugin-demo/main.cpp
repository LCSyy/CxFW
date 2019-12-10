#include <QCoreApplication>
#include <QGenericPluginFactory>
#include <QPluginLoader>
#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    qDebug() << QCoreApplication::applicationDirPath();
    QCoreApplication::addLibraryPath(QCoreApplication::applicationDirPath() + "/plugins");

    QPluginLoader quickPlugin("quickplugind");
    if(quickPlugin.load()) {
        qDebug() << "It's Ok!";
        qDebug() << quickPlugin.metaData().toVariantMap();

    }
    qDebug() << QGenericPluginFactory::keys();
    return a.exec();
}
