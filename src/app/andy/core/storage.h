#ifndef STORAGE_H
#define STORAGE_H

#include <QObject>

class Storage : public QObject
{
    Q_OBJECT
public:
    explicit Storage(QObject *parent = nullptr);
    ~Storage();

signals:
    void storageInitialed();
    void dataLoaded(const QVariantList&);
    void dataCreated();
    void dataRemoved();
    void dataAltered();

public slots:
    void initDatabase(const QString &dbPath);
    void dropDatabase();
    void loadDataList();
    void createData(const QVariantMap &row);
    void removeData(const QString &id);
    void alterData(const QString &id, const QString &key, const QVariant &val);
};

#endif // STORAGE_H
