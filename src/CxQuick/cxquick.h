#ifndef CXQUICK_H
#define CXQUICK_H

#include <QObject>
#include <QColor>

class CxQuick: public QObject {
    Q_OBJECT
    Q_PROPERTY(int insets READ insets CONSTANT)
    Q_PROPERTY(int paddings READ paddings CONSTANT)
    Q_PROPERTY(int spacing READ spacing CONSTANT)
    Q_PROPERTY(QColor background READ background CONSTANT)
    Q_PROPERTY(QColor backgroundInActive READ backgroundInActive CONSTANT)
    Q_PROPERTY(QColor backgroundActive READ foregroundActive CONSTANT)
    Q_PROPERTY(QColor foreground READ foreground CONSTANT)
    Q_PROPERTY(QColor foregroundInActive READ foregroundInActive CONSTANT)
    Q_PROPERTY(QColor foregroundActive READ foregroundActive CONSTANT)

public:
    explicit CxQuick(QObject *parent = nullptr);

    int insets() const { return mInsets; }
    int paddings() const { return mPaddings; }
    int spacing() const { return mSpacing; }

    QColor background() const { return mBgColor; }
    QColor backgroundInActive() const { return QColor("#897946"); }
    QColor backgroundActive() const { return QColor("#568979"); }

    QColor foreground() const { return mFgColor; }
    QColor foregroundInActive() const { return QColor("#897946"); }
    QColor foregroundActive() const { return QColor("#568979"); }

private:
    int mInsets{8};
    int mPaddings{4};
    int mSpacing{2};

    QColor mBgColor{"grey"};
    QColor mFgColor{"white"};
};

#endif // CXQUICK_H
