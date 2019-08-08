#ifndef CXBASE_H
#define CXBASE_H

#include "cxbase_global.h"
#include <QBitArray>

namespace cx {

struct QRCode
{
    QRCode(uint8_t iSize)
        : size(iSize)
        , modules(iSize*iSize,false)
    {}

    uint8_t size;
    QBitArray modules;
};

class CXBASESHARED_EXPORT Cxbase
{
public:
    static QRCode genQRcode(uint8_t version, uint8_t ecc, const char *data);

    static const QString encryptText(const QString &clearText, const QString &passphrase);
    static const QString decryptText(const QString &cryptedText, const QString &passphrase);
};

}

#endif // CXBASE_H
