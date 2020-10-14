#ifndef JSONCONVERTER_H
#define JSONCONVERTER_H

#include <QVariantMap>

class JsonConverter
{
public:
    JsonConverter();

    static QVariantMap bytesToJsonMap(const QByteArray &ba);
};

#endif // JSONCONVERTER_H
