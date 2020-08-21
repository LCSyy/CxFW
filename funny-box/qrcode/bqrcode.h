#ifndef BQRCODE_H
#define BQRCODE_H

#include <vector>
#include <cstdint>

struct BQRCodePrivate;
class BQRCode {
public:
    BQRCode();
    ~BQRCode();

    std::vector<uint8_t> genQRCode(const char *msg, uint8_t version, uint8_t ecc = 0);

private:
    BQRCodePrivate *p;
};

#endif
