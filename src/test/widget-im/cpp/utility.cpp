#include "utility.h"
#include <QFontMetrics>

Utility::Utility(QObject *parent) : QObject(parent)
{

}

int Utility::textLineCount(const QString &text) const
{
    return text.count('\n') + 1;
}
