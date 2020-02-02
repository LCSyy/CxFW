#include "mainwindow.h"
#include <QToolBar>
#include <QTextEdit>
#include <QFont>
#include <QShortcut>
#include <QKeySequence>

#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>

#include <QDebug>

LocalDB::LocalDB(QObject *parent)
    : QObject(parent)
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE","pims_local");
    db.setDatabaseName("pims_local.db");
    if (!db.open()) {
        qDebug() << db.lastError().text();
    } else {
    }
}

LocalDB::~LocalDB()
{
    QSqlDatabase::database().close();
}

void LocalDB::initPIMS()
{
    QSqlQuery query(QSqlDatabase::database("pims_local"));
    query.exec("CREATE TABLE IF NOT EXISTS pims("
               "id INTEGER PRIMARY KEY ASC,"
               "module TEXT UNIQUE NOT NULL,"
               "config TEXT,"
               "desc TEXT);");
    query.prepare("INSERT INTO pims VALUES(null,?,?,?)");

    QVariantList moduleLst{"members","note","finance","plan","contact"};
    query.addBindValue(moduleLst);
    QVariantList configLst{R"({"ui":{}})",R"({"ui":{"TextEdit":{"font":{"pointSize":14}}}})",QVariant(QVariant::String),QVariant(QVariant::String),QVariant(QVariant::String)};
    query.addBindValue(configLst);
    QVariantList descLst{"Family members information.","Diary, work log, notes, etc.","Your finance.","Your work or life plans.","Your contact list. Includes email, phone number, social network, etc."};
    query.addBindValue(descLst);
    if (!query.execBatch()) {
        qDebug() << query.lastError().text();
    }
}

void LocalDB::initNoteModule()
{
    QSqlQuery query(QSqlDatabase::database("pims_local"));
    query.exec("CREATE TABLE IF NOT EXISTS note("
               "id INTEGER PRIMARY KEY ASC,"
               "title TEXT,"
               "labels TEXT,"
               "content TEXT,"
               "create_dt TEXT,"
               "edit_dt TEXT);");
}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , mTextEdit(new QTextEdit(this))
    , mLocalDB(new LocalDB(this))
{
    QToolBar *toolBar = new QToolBar(this);
    toolBar->setAllowedAreas(Qt::TopToolBarArea);
    toolBar->setFloatable(false);
    toolBar->setMovable(false);
    addToolBar(Qt::TopToolBarArea,toolBar);

    mTextEdit->setFontPointSize(14);
    setCentralWidget(mTextEdit);

    QShortcut *saveShortCut = new QShortcut(QKeySequence("Ctrl+S"),mTextEdit);
    connect(saveShortCut,SIGNAL(activated()), this, SLOT(onSave()));

    resize(800,600);
}

MainWindow::~MainWindow()
{
}

void MainWindow::onSave()
{
    qDebug() << mTextEdit->toPlainText();
}

