#include <cxbase/cxbase.h>

#include <QDebug>

int main() {
    const QString clearText{"This is test."};
    const QString encStr = cx::CxBase::encryptText(clearText,"abc");
    qDebug().noquote() << "encrypt:" << encStr;

    qDebug() << "decrypt:" << cx::CxBase::decryptText(encStr,"abc");
}
