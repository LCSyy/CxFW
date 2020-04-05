#ifndef LOCALSTORAGETHREAD_H
#define LOCALSTORAGETHREAD_H

#include <QObject>
#include <QThread>
#include <QVariantMap>

class LocalStorageThread : public QThread
{
    Q_OBJECT
public:
    explicit LocalStorageThread(QObject *parent = nullptr);
    ~LocalStorageThread() override;

    void initDatabase(const QString &dbPath);
    void dropDatabase();
    void loadData(const QString &sql, const QStringList &fields);

    const QVariantList &dataRows() const;

protected:
    void run() override;

private:
    void initDB(const QString &dbPath);
    void removeDB();
    void pLoadData(const QString &sql, const QStringList &fields);

private:
    QString invokeName;
    QVariantMap invokeParams;
    QVariantList datas;
};

#endif // LOCALSTORAGETHREAD_H
