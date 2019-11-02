#ifndef CHATITEM_H
#define CHATITEM_H

#include <QQuickPaintedItem>
#include <QFontMetrics>

class ChatItem : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)
    Q_PROPERTY(int side READ side WRITE setSide NOTIFY sideChanged)
signals:
    void textChanged(const QString &text);
    void sideChanged(int side);

public:
    explicit ChatItem(QQuickItem *parent = nullptr);

    void paint(QPainter *painter) override;

    const QString &text() const { return mMsgText; }
    void setText(const QString &text);

    int side() const { return mMsgSide; }
    void setSide(int side);

private:
    int mMsgSide{0};
    QString mMsgText;
    QFontMetrics mMsgMetrics;
};

#endif // CHATITEM_H
