#include <QCoreApplication>
#include <QFile>
#include <QTextStream>
#include <QDataStream>
#include <botan/version.h>
#include <botan/system_rng.h>
#include <botan/hash.h>
#include <botan/cryptobox.h>
#include <iostream>
#include <cstring>

#include <QDebug>

int main(int argc, char *argv[])
{
    Q_UNUSED(argc)
    Q_UNUSED(argv)

    // version
    std::cout << "---- version ----" << std::endl;
    std::cout << Botan::version_string() << std::endl;
    // secure memory
    std::cout << "---- secure memory ----" << std::endl;
    Botan::secure_vector<char> sec;
    std::cout << sec.size() << std::endl;

    // randome number generator

    std::cout << "---- rng ----" << std::endl;
    Botan::System_RNG  rng;
    Botan::secure_vector<Botan::uint8_t> rn(12,0);
    rng.randomize(rn.data(),12);
    for(Botan::uint8_t ch: rn) {
        std::cout << ch << std::endl;
    }

    // hash function
    std::cout << "---- hash function ----" << std::endl;
    auto hashFunc = Botan::HashFunction::create("MD5");
    hashFunc->update(std::string{"This is a test."});
    std::cout << "output length:" << hashFunc->output_length() << std::endl;
    for(auto &ch: hashFunc->final()) {
        std::cout << static_cast<uint>(ch);
    }
    std::cout << std::endl;

    // encrypt/decrypt data
    QString encStr;
    QFile f("F:/Projects/git/CxFrameworks/README.md");
    if(f.open(QFile::ReadOnly)) {
        qint64 size = f.bytesAvailable();
        uint8_t *data = f.map(0,size);

        encStr = QString::fromStdString(Botan::CryptoBox::encrypt(data,static_cast<std::size_t>(size),"ABC",rng));
    }
    f.close();

    if(!encStr.isEmpty()) {
        f.setFileName("enc.pck");
        if(f.open(QFile::WriteOnly)) {
            QDataStream out(&f);
            out << encStr;
        }
        f.close();

        if(f.open(QFile::ReadOnly)) {
            QDataStream in(&f);
            QString text;
            in >> text;
            qDebug().noquote().nospace() << QString::fromStdString(Botan::CryptoBox::decrypt(text.toStdString(),"ABC"));
        }
        f.close();
    }

    return 0;
}
