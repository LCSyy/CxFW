// cxfw CxFW包管理器
// 1.获取编译第三方库
// 2.为开发应用安装cxfw sdk
// ...

#include <QCoreApplication>
#include <QCommandLineParser>
#include <QCommandLineOption>

#include <QDebug>

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);
    QCoreApplication::setApplicationName("cxfw");
    QCoreApplication::setApplicationVersion("1.0");

    QCommandLineParser parser;
    parser.setApplicationDescription("CxFW packages manager");
    parser.addHelpOption();
    parser.addVersionOption();
    // parser.addPositionalArgument("command", QCoreApplication::translate("main", "Sub command to run."));
    // parser.addPositionalArgument("destination", QCoreApplication::translate("main", "Destination directory."));

    QCommandLineOption showProgressOption(QStringList{"i","install"},
                                          QCoreApplication::translate("main", "Install sdk."),
                                          QCoreApplication::translate("main", "sdk name"));
    parser.addOption(showProgressOption);

    QCommandLineOption forceOption(QStringList{"f","force"},
            QCoreApplication::translate("main", "Overwrite existing files."));
    parser.addOption(forceOption);

    parser.process(a);

    const QStringList args = parser.positionalArguments();
    bool force = parser.isSet(forceOption);
    bool showProgress = parser.isSet(showProgressOption);
    QString targetDir = parser.value(showProgressOption);

    qDebug() << targetDir;

    return a.exec();
}
