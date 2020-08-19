#ifndef QRGENERATOR_H
#define QRGENERATOR_H

#include <QObject>

class QrGenerator : public QObject
{
    Q_OBJECT
public:
    explicit QrGenerator(QObject *parent = nullptr);

    Q_INVOKABLE QVector<bool> genQrCode() const;

};

#endif // QRGENERATOR_H
