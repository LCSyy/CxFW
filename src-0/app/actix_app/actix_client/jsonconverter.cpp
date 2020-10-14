#include "jsonconverter.h"
#include <QJsonDocument>

JsonConverter::JsonConverter()
{

}

QVariantMap JsonConverter::bytesToJsonMap(const QByteArray &ba)
{
    QJsonDocument doc = QJsonDocument::fromJson(ba);
    return doc.toVariant().toMap();
}
