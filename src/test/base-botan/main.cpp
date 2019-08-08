#include <cxbase/cxbase.h>

#include <QDebug>

int main() {
    const QString clearText{"This is test."};
    const QString encStr = cx::Cxbase::encryptText(clearText,"abc");
    qDebug().noquote() << "encrypt:" << encStr;

    qDebug() << "decrypt:" << cx::Cxbase::decryptText(encStr,"abc");
}
