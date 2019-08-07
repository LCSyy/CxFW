#include "cxbase.h"
#include "qrcode/qrcode.h"

#include "botan/version.h"

#include <QDebug>

namespace cx {

QRCode Cxbase::genQRcode(uint8_t version, uint8_t ecc, const char *data)
{
    ::QRCode code;

    uint8_t *buffer = new uint8_t[qrcode_getBufferSize(version)];
    ::qrcode_initText(&code,buffer,version,ecc,data);

    QRCode cxCode(code.size);

    for (uint8_t y = 0; y < code.size; y++) {
        for (uint8_t x = 0; x < code.size; x++) {
            if (qrcode_getModule(&code, x, y)) {
                cxCode.modules.setBit(x+code.size*y,true);
            } else {
                cxCode.modules.setBit(x+code.size*y,false);
            }
        }
    }

    delete[] buffer;
    buffer = nullptr;

    return cxCode;
}

void Cxbase::cryto()
{
    qDebug() << QString::fromStdString(Botan::version_string());
}

}

