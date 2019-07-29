#ifndef STORAGE_H
#define STORAGE_H

#include <QObject>
#include <QVector>
#include <QVariantList>
#include "cxbase_global.h"

namespace cx {

class CXBASESHARED_EXPORT Storage: public QObject
{
    Q_OBJECT
public:
    explicit Storage(const QString &dataPath, QObject *parent = nullptr);
    ~Storage();

    uint prepareRequest() {
        requestIdPtr += 1;
        dataRequestQueue.push_back(requestIdPtr);
        return requestIdPtr;
    }

    QVariant finishRequest(uint requestId) {
        dataRequestQueue.removeOne(requestId);
        return dataPool.take(requestId);
    }

    static uint currentRequestId() { return requestIdPtr; }
    static QVector<uint> &getDataRequestQueue();
    static QMap<uint, QVariant> &getDataPool();

public slots:
    QVariantList appInfo();
    QVariantList loadData();
    void saveData(const QVariantMap &rowMap);

private:
    static uint requestIdPtr;
    static QVector<uint> dataRequestQueue;
    static QMap<uint,QVariant> dataPool;
};

}

#endif // STORAGE_H
