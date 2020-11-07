#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include <QToolButton>
#include <QFileDialog>
#include <QFile>
#include <QTextStream>
#include <QScrollBar>
#include <QGraphicsDropShadowEffect>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    initUI();
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::initUI()
{
    ui->setupUi(this);

    initStatusBar(ui->statusbar);

    QLayout *layout = ui->contentWidget->layout();
    if (layout) {
        layout->setAlignment(Qt::AlignHCenter);
    }

    ui->markdownEdit->setWordWrapMode(QTextOption::WrapAnywhere);
    ui->markdownEdit->viewport()->setContentsMargins(100,10,100,10);

    QGraphicsDropShadowEffect *effect = new QGraphicsDropShadowEffect(ui->markdownEdit);
    effect->setBlurRadius(50);
    effect->setOffset(0);
    ui->markdownEdit->setGraphicsEffect(effect);

    reflectScrollBar();
}

void MainWindow::initStatusBar(QStatusBar *statusbar)
{
    m_sideBarButton = new QToolButton(statusbar);
    m_sideBarButton->setText("O");
    m_sideBarButton->setToolTip(tr("Open/Hide side bar"));
    statusbar->addWidget(m_sideBarButton);
}

void MainWindow::reflectScrollBar()
{
    QScrollBar *docBar = ui->markdownEdit->verticalScrollBar();
    QScrollBar *sideBar = ui->verticalScrollBar;

    connect(docBar,&QAbstractSlider::rangeChanged,[sideBar](int min, int max){
        sideBar->setRange(min,max);
    });
    connect(docBar,SIGNAL(valueChanged(int)),
            sideBar,SLOT(setValue(int)));

    connect(sideBar,&QAbstractSlider::actionTriggered,[docBar](int action){
        docBar->triggerAction(static_cast<QAbstractSlider::SliderAction>(action));
    });
    connect(sideBar,SIGNAL(sliderMoved(int)),
            docBar,SLOT(setValue(int)));

    docBar->setRange(0,1);
    docBar->setValue(0);
}

void MainWindow::on_actionOpenFile_triggered()
{
    const QStringList fileNames = QFileDialog::getOpenFileNames(this,
                                           tr("Select files"),
                                           "",
                                                                "Markdown (*.md *.markdown)");
    for (const QString &fileName: fileNames) {
        appendFileToList(fileName);
    }

    if (fileNames.length() > 0) {
        const QString &name = fileNames.value(0);
        QFileInfo info(name);

        openFile(info.absoluteFilePath());

        setWindowTitle(info.fileName() + " - CxWriter");
    }
}

void MainWindow::openFile(const QString &fileName)
{
    QFile f(fileName);
    if (!f.open(QFile::ReadOnly)) {
        return;
    }

    QTextStream in(&f);
    in.setCodec("utf-8");

    ui->markdownEdit->setText(in.readAll());

    in.flush();
    f.close();
}

void MainWindow::appendFileToList(const QString &fileName)
{
    Q_UNUSED(fileName)
}

bool MainWindow::eventFilter(QObject *obj, QEvent *ev)
{
    return QMainWindow::eventFilter(obj,ev);
}
