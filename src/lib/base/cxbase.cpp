#include "cxbase.h"
#include <QByteArray>
#include <botan/system_rng.h>
#include <botan/cryptobox.h>
#include "qrcode/qrcode.h"

#include <iostream>
#include <QDebug>

namespace cx {

QRCode CxBase::genQRcode(uint8_t version, uint8_t ecc, const char *data)
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

const QString CxBase::encryptText(const QString &clearText, const QString &passphrase)
{
    QByteArray ba = clearText.toUtf8();
    std::size_t cpySize = static_cast<std::size_t>(ba.size());
    QString encStr;
    if(cpySize) {
        uint8_t *tmpMem = new uint8_t[cpySize + 1];
        std::memset(tmpMem,0,cpySize + 1);
        std::memcpy(tmpMem,ba.data(),cpySize);
        encStr = QString::fromStdString(Botan::CryptoBox::encrypt(tmpMem,cpySize,passphrase.toStdString(),Botan::system_rng()));
        std::memset(tmpMem,0,cpySize);
        delete[] tmpMem;
        tmpMem = nullptr;
    }
    return encStr;
}

const QString CxBase::decryptText(const QString &cryptedText, const QString &passphrase)
{
    return QString::fromStdString(Botan::CryptoBox::decrypt(cryptedText.toStdString(), passphrase.toStdString()));
}

}

