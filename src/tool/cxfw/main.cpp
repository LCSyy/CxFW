// cxfw CxFW包管理器
// 1.获取编译第三方库
// 2.为开发应用安装cxfw sdk
// ...

#include <QCoreApplication>
#include <QCommandLineParser>
#include <QCommandLineOption>
#include <iostream>

int main(int argc, char *argv[])
{
    QCoreApplication app(argc, argv);
    QCoreApplication::setApplicationName("cxfw");
    QCoreApplication::setApplicationVersion("1.0");

    QCommandLineParser parser;
    parser.setApplicationDescription("CxFW packages manager");
    parser.addHelpOption();
    parser.addVersionOption();
    // parser.addPositionalArgument("source", QCoreApplication::translate("main", "Source file to copy."));
    // parser.addPositionalArgument("destination", QCoreApplication::translate("main", "Destination directory."));

    QCommandLineOption showProgressOption("p",
                                          QCoreApplication::translate("main", "Show progress during copy"));
    parser.addOption(showProgressOption);

    QCommandLineOption forceOption(QStringList() << "f" << "force",
                                   QCoreApplication::translate("main", "Overwrite existing files."));
    parser.addOption(forceOption);

    QCommandLineOption targetDirectoryOption(QStringList() << "t" << "target-directory",
            QCoreApplication::translate("main", "Copy all source files into <directory>."),
            QCoreApplication::translate("main", "directory"));
    parser.addOption(targetDirectoryOption);

    parser.process(app);

    bool showProgress = parser.isSet(showProgressOption);
    // bool force = parser.isSet(forceOption);
    // QString targetDir = parser.value(targetDirectoryOption);

    if(showProgress) {
        std::cout << "----- 100% -----" << std::endl;
    }
}
