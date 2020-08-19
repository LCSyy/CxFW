#include "qrgenerator.h"
#include "qrcode.h"

#include <iostream>

QrGenerator::QrGenerator(QObject *parent) : QObject(parent)
{

}

QVector<bool> QrGenerator::genQrCode() const
{
    const char *msg = "This is important information.";
    constexpr uint8_t VERSION = 1;
    QRCode qrcode;
    const uint16_t buffer_size = qrcode_getBufferSize(VERSION);
    uint8_t modules[buffer_size];
    qrcode_initText(&qrcode,modules,VERSION,ECC_LOW, msg);

    std::cout << "buffer_size:" << static_cast<int>(buffer_size) << std::endl;
    std::cout << "code size:" << static_cast<int>(qrcode.size) << std::endl;

    QVector<bool> m(static_cast<int>(qrcode.size*qrcode.size), false);
    for (int row = 0; row < qrcode.size; ++row) {
        const int row_full = row * qrcode.size;
        for (int col = 0; col < qrcode.size; ++col) {
            if (qrcode_getModule(&qrcode,col,row)) {
                m[row_full+col] = true;
                std::cout << "*";
            } else {
                std::cout << "-";
            }
        }
        std::cout << std::endl;
    }

    return m;
}
