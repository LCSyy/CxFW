#include "cxbufferlistmodel.h"
#include <QFile>
#include <QTextStream>
#include <QTextDocument>
#include <QPlainTextDocumentLayout>
#include <QFileSystemWatcher>
#include <QBrush>
#include <QDebug>

namespace {
const char DOC_CODEC[] = "UTF-8";
}

CxBufferListModel::CxBufferListModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_fileWatcher(new QFileSystemWatcher(this))
{

}

CxBufferListModel::~CxBufferListModel()
{
    qDeleteAll(m_buffers);
}

int CxBufferListModel::rowCount(const QModelIndex &parnet) const
{
    Q_UNUSED(parnet)
    return m_buffers.size();
}

QVariant CxBufferListModel::data(const QModelIndex &index, int role) const
{
    const int row = index.row();
    if (row < 0 || rowCount() <= row) {
        return QVariant();
    }

    CxFileBuffer *buffer = m_buffers[row];
    if (!buffer) {
        return QVariant();
    }

    Qt::ItemDataRole r = static_cast<Qt::ItemDataRole>(role);
    switch (r) {
    case Qt::DisplayRole:
        return buffer->fileInfo().fileName();
    case Qt::ToolTipRole:
        return buffer->fileInfo().absoluteFilePath();
    case Qt::ForegroundRole:
        return QBrush(Qt::black);
    default:
        ;
    }

    return QVariant();
}

QModelIndex CxBufferListModel::index(int row, int column, const QModelIndex &parent) const
{
    Q_UNUSED(column)
    Q_UNUSED(parent)
    if (row < 0 || rowCount() <= row) {
        return QModelIndex();
    }

    CxFileBuffer *buffer = m_buffers[row];
    if (!buffer) { return QModelIndex(); }

    return createIndex(row,0,reinterpret_cast<void*>(buffer));
}

bool CxBufferListModel::setData(const QModelIndex &index, const QVariant &value, int role)
{
    const int row = index.row();
    if (row < 0 || rowCount() <= row) { return false; }

    CxFileBuffer *buffer = m_buffers[row];
    if (!buffer) { return false;}

    bool changed = false;
    const Qt::ItemDataRole r = static_cast<Qt::ItemDataRole>(role);
    switch (r) {
    case Qt::DisplayRole:
        buffer->setText(value.toString());
        changed = true;
        break;
    case Qt::ToolTipRole:
        buffer->m_fileInfo.setFile(value.toString());
        changed = true;
        break;
    default:
        ;
    }

    if (changed) {
        emit dataChanged(index,index,{r});
    }

    return changed;
}

void CxBufferListModel::appendRows(const QStringList &fileNames)
{
    const int startRow = rowCount();

    int existsCount = 0;
    QStringList existsFiles;
    for (const CxFileBuffer *buffer: m_buffers) {
        if (buffer) {
            const QString file = buffer->m_fileInfo.absoluteFilePath();
            existsFiles.append(file);

            if (fileNames.contains(file)) {
                ++existsCount;
            }
        }
    }

    const int endRow = startRow + (fileNames.size() - existsCount - 1);
    if (endRow < startRow) { return; }


    beginInsertRows(QModelIndex(),startRow,endRow);

    for (const QString &fileName: fileNames) {
        if (existsFiles.contains(fileName)) { continue; }

        CxFileBuffer *buffer = new CxFileBuffer(fileName);
        m_buffers.append(buffer);
    }

    endInsertRows();
}

bool CxBufferListModel::removeRows(int row, int count, const QModelIndex &index)
{
    Q_UNUSED(index)

    const int last = row + (count - 1);
    if (last < row) { return false; }

    beginRemoveRows(QModelIndex(), row, last);
    for (int i = row; i < m_buffers.size() && i <= last; ++i) {
        CxFileBuffer *buffer = m_buffers.takeAt(i);
        if (buffer) {
            delete buffer;
            buffer = nullptr;
        }
    }
    endRemoveRows();

    return true;
}

/// 加载指定名称的文件
CxFileBuffer::CxFileBuffer(const QString &fileName)
{
    open(fileName);
}

CxFileBuffer::~CxFileBuffer()
{
    close();
}

void CxFileBuffer::open(const QString &fileName)
{
    m_fileInfo.setFile(fileName);
    if (m_fileInfo.exists() && m_fileInfo.isFile()) {
        QFile f(m_fileInfo.absoluteFilePath());
        if (!f.open(QFile::ReadOnly)) {
            m_fileInfo.setFile("");
            return;
        }

        QTextStream in(&f);
        in.setCodec(DOC_CODEC);
        m_text = in.readAll();
        in.flush();
        f.close();
    }
}

void CxFileBuffer::save(const QString &fileName)
{
    if (!fileName.isEmpty()) {
        m_fileInfo.setFile(fileName);
    }

    const QString filePath = m_fileInfo.absoluteFilePath();
    if (filePath.isEmpty()) {
        return;
    }

    QFile f(filePath);
    if (!f.open(QFile::WriteOnly)) {
        return;
    }

    QTextStream out(&f);
    out.setCodec(DOC_CODEC);
    out << m_text;
    out.flush();
    f.close();
}

void CxFileBuffer::close()
{
    m_fileInfo.setFile("");
    m_text.clear();
}

void CxFileBuffer::setText(const QString &text)
{
    m_text = text;
}

const QString &CxFileBuffer::text() const
{
    return m_text;
}

const QFileInfo &CxFileBuffer::fileInfo() const
{
    return m_fileInfo;
}
