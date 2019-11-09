#include "textmetrics.h"
#include <QDebug>

TextMetrics::TextMetrics(QObject *parent)
    : QObject(parent)
    , mMetrics(QFont())
{

}

QRect TextMetrics::boundingRect(const QRect &rect, const QString &text) const
{
    return mMetrics.boundingRect(rect,Qt::AlignLeft | Qt::TextWrapAnywhere,text);
}

