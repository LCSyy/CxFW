#ifndef CXBUFFERLISTMODEL_H
#define CXBUFFERLISTMODEL_H

#include <QAbstractListModel>
#include <QFileInfo>
#include <QModelIndex>

QT_BEGIN_NAMESPACE
class QTextDocument;
class QFileSystemWatcher;
QT_END_NAMESPACE

class CxFileBuffer;

class CxBufferListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    CxBufferListModel(QObject *parent = nullptr);
    ~CxBufferListModel();

    int rowCount(const QModelIndex &parnet = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QModelIndex index(int row, int column = 0, const QModelIndex &parent = QModelIndex()) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;

    void appendRows(const QStringList &fileNames);
    bool removeRows(int row, int count, const QModelIndex &index = QModelIndex()) override;

private:
    QFileSystemWatcher *m_fileWatcher;
    QList<CxFileBuffer*> m_buffers;
};


class CxFileBuffer {
    friend class CxBufferListModel;
public:
    CxFileBuffer(const QString &fileName = QString());
    ~CxFileBuffer();

    void open(const QString &fileName);
    void save(const QString &fileName = QString());
    void close();

    void setText(const QString &text);
    const QString &text() const;
    const QFileInfo &fileInfo() const;


private:
    QFileInfo m_fileInfo;
    QString m_text;
};

#endif // CXBUFFERLISTMODEL_H
