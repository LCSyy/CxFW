#ifndef LOCALSTORAGEWORKER_H
#define LOCALSTORAGEWORKER_H

#include <QObject>

class LocalStorageWorker: public QObject
{
    Q_OBJECT
public:
    explicit LocalStorageWorker(QObject *parent = nullptr);
    ~LocalStorageWorker();

public slots:
    void initDatabase(const QString &dbPath);
    void dropDatabase();
    void createData(const QVariantMap &row);
    void removeData(const QString &id);
    QVariantList loadData(const QString &sql,const QStringList &fields);
    void alterData(const QString &id, const QString &key, const QVariant &val);
};

#endif // LOCALSTORAGEWORKER_H
