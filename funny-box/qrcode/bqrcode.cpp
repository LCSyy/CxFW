#include "bqrcode.h"
#include "qrcode.h"

#include <iostream>

struct BQRCodePrivate {
    QRCode qrcode;
};

BQRCode::BQRCode()
    : p(new BQRCodePrivate)
{

}

BQRCode::~BQRCode()
{
    if (p) { delete p; }
}

std::vector<uint8_t> BQRCode::genQRCode(const char *msg, uint8_t version, uint8_t ecc)
{
    const uint16_t buffSize = qrcode_getBufferSize(version);
    uint8_t modules[buffSize];
    if (qrcode_initText(&(p->qrcode),modules,version,ecc,msg) == 0) {
        const uint8_t size = p->qrcode.size;
        std::vector<uint8_t> codes(size*(size+1),0);
        for (uint8_t row = 0; row < size; ++row) {
            for (uint8_t col = 0; col < size; ++col) {
                if (qrcode_getModule(&(p->qrcode),col,row)) {
                    codes[row*size+col] = 1;
                }
            }
            codes[row*(size+1)] = 2;
        }
        return codes;
    }
    return std::vector<uint8_t>(0);
}
