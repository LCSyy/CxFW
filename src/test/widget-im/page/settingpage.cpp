#include "settingpage.h"
#include <QFormLayout>
#include <QLineEdit>

SettingPage::SettingPage(QWidget *parent)
    : QWidget(parent)
{
    QFormLayout *formLayout = new QFormLayout(this);
    QLineEdit *field = new QLineEdit(this);
    formLayout->addRow("Setting",field);
}
