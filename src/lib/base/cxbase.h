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
    QRCode genQRcode(uint8_t version, uint8_t ecc, const char *data);
    void cryto();
};

}

#endif // CXBASE_H
