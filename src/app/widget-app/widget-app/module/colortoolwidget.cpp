#include "colortoolwidget.h"
#include <QVBoxLayout>
#include <QFormLayout>
#include <QLineEdit>
#include <QPushButton>
#include <QColor>
#include <QRegularExpression>
#include "mainwindow.h"

ColorToolWidget::ColorToolWidget(QWidget *parent)
    : QWidget(parent)
{
    QVBoxLayout *vlayout = new QVBoxLayout(this);
    vlayout->setSpacing(25);

    QFormLayout *formlayout = new QFormLayout;
    formlayout->setVerticalSpacing(3);
    vlayout->addLayout(formlayout);

    QLineEdit *colorField = new QLineEdit(this);
    colorField->setPlaceholderText(tr("format: #888888|grey|#888|125,125,125|0.5,0.5,0.5"));
    formlayout->addRow(tr("Color"),colorField);

    mColorWgt = new QWidget(this);
    mColorWgt->setMinimumSize(50,20);
    formlayout->addRow(tr("result"),mColorWgt);

    mShapeField = new QLineEdit(this);
    mShapeField->setReadOnly(true);
    formlayout->addRow(tr("#RRGGBB"),mShapeField);

    mRgbField = new QLineEdit(this);
    mRgbField->setReadOnly(true);
    formlayout->addRow(tr("(R,G,B)"),mRgbField);

    mRgbdField = new QLineEdit(this);
    mRgbdField->setReadOnly(true);
    formlayout->addRow(tr("(R,G,B)"),mRgbdField);

    mSnapBtn = new QPushButton(tr("snap"),this);
    vlayout->addWidget(mSnapBtn);

    mImgBtn = new QPushButton(tr("image"),this);
    vlayout->addWidget(mImgBtn);

    vlayout->addStretch(9999);
    connect(colorField,SIGNAL(textEdited(const QString&)),
            this,SLOT(onColorFieldEdited(const QString&)));
    connect(mSnapBtn,SIGNAL(clicked()),this,SLOT(onSnapBtnClicked()));
}

void ColorToolWidget::onColorFieldEdited(const QString &text)
{
    QColor color;
    QString tT = text.trimmed();

    if(tT.startsWith('(') || tT.endsWith(')')) {
        tT.remove(QRegularExpression("^\\(|\\)$"));
    }
    if(tT.startsWith('#')) {
        color.setNamedColor(tT);
    } else {
        QStringList colors = tT.split(',');
        if(colors.size() == 3) {
            bool ok{false};
            const int red = colors[0].trimmed().toInt(&ok);
            if(ok) { color.setRed(red); }
            else {
                const double red = colors[0].trimmed().toDouble();
                if(ok) { color.setRedF(red); }
            }

            const int green = colors[1].trimmed().toInt(&ok);
            if(ok) { color.setGreen(green); }
            else {
                const double green = colors[1].trimmed().toDouble(&ok);
                if(ok) {color.setGreenF(green); }
            }

            const int blue = colors[2].trimmed().toInt(&ok);
            if(ok) { color.setBlue(blue); }
            else {
                const double blue = colors[2].trimmed().toDouble(&ok);
                if(ok) { color.setBlueF(blue); }
            }
        }
    }

    if(color.isValid()) {
        mColorWgt->setStyleSheet(QString("background-color:%1").arg(color.name()));
        mShapeField->setText(color.name());
        mRgbField->setText(QString("(%1,%2,%3)").arg(color.red()).arg(color.green()).arg(color.blue()));
        mRgbdField->setText(QString("(%1,%2,%3)")
                            .arg(color.redF(),0,'g',3)
                            .arg(color.greenF(),0,'g',3)
                            .arg(color.blueF(),0,'g',3));
    } else {
        mColorWgt->setStyleSheet("background-color:black");
        mShapeField->clear();
        mRgbField->clear();
        mRgbdField->clear();
    }
}

void ColorToolWidget::onSnapBtnClicked()
{
    MainWindow::self()->showMinimized();
}
