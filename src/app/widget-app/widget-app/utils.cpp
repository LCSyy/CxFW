#include "utils.h"
#include <QDateTime>
#include <QDate>
#include <QTime>

#include <QDebug>

Utils::Utils(QObject *parent) : QObject(parent)
{

}

QVariantMap Utils::now() const
{
    const QDateTime dt = QDateTime::currentDateTime();
    const QDate date = dt.date();
    const QTime time = dt.time();
    QVariantMap dtMap;
    dtMap.insert("y",date.year());
    dtMap.insert("mo",date.month());
    dtMap.insert("d",date.day());
    dtMap.insert("h",time.hour());
    dtMap.insert("mi",time.minute());
    dtMap.insert("s",time.second());
    return dtMap;
}

qint64 Utils::timeDurationSeconds(const QVariantMap &start, const QVariantMap &end) const
{
    QDateTime startDT(QDate(start.value("y").toInt(),start.value("mo").toInt(),start.value("d").toInt()),
                    QTime(start.value("h").toInt(),start.value("mi").toInt(),start.value("s").toInt()));
    QDateTime endDT(QDate(end.value("y").toInt(),end.value("mo").toInt(),end.value("d").toInt()),
                    QTime(end.value("h").toInt(),end.value("mi").toInt(),end.value("s").toInt()));
    return startDT.secsTo(endDT);
}

QString Utils::dateTime2Str(const QVariantMap &dt) const
{
    return QString("%1-%2-%3 %4:%5:%6")
            .arg(dt.value("y").toInt())
            .arg(dt.value("mo").toInt())
            .arg(dt.value("d").toInt())
            .arg(dt.value("h").toInt())
            .arg(dt.value("mi").toInt())
            .arg(dt.value("s").toInt());
}
