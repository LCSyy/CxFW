#include "utils.h"
#include "qrcode.h"
#include <QVariantList>

namespace {

QVariantList qrcodeGenerator() {
    QVariantList ms;
    const uint16_t bufSize = qrcode_getBufferSize(1);
    QRCode qrcode;
    uint8_t modules[bufSize];
    qrcode_initText(&qrcode, modules, 1, ECC_LOW,"This is test");
    for (uint8_t y = 0; y < qrcode.size; ++y) {
        QVariantList row;
        for (uint8_t x = 0; x < qrcode.size; ++x) {
            if (qrcode_getModule(&qrcode,x,y)) {
                row.append(1);
            } else {
                row.append(0);
            }
        }
        ms.append(QVariant::fromValue(row));
    }
    return ms;
}

}

Utils::Utils(QObject *parent) : QObject(parent)
{

}

QVariantList Utils::genQRCode() const
{
    return QVariantList{};
    // return qrcodeGenerator();
}

