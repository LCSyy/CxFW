#include "textmetrics.h"

TextMetrics::TextMetrics(QObject *parent)
    : QObject(parent)
    , mMetrics(QFont())
{

}

QRect TextMetrics::boundingRect(const QRect &rect, const QString &text) const
{
    return mMetrics.boundingRect(rect,Qt::TextWordWrap,text);
}

QSize TextMetrics::size(const QString &str) const
{
    return mMetrics.size(Qt::TextWordWrap,str);
}
