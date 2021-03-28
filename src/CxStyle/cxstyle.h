#ifndef CXSTYLE_H
#define CXSTYLE_H

#include <QObject>
#include <QColor>

class CxStyle : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int margins READ margins CONSTANT)
    Q_PROPERTY(int insets READ insets CONSTANT)
    Q_PROPERTY(int paddings READ paddings CONSTANT)
    Q_PROPERTY(int spacing READ spacing CONSTANT)
    Q_PROPERTY(int contentHeight READ contentHeight CONSTANT)
    Q_PROPERTY(QColor background READ background CONSTANT)
    Q_PROPERTY(QColor backgroundInActive READ backgroundInActive CONSTANT)
    Q_PROPERTY(QColor backgroundActive READ foregroundActive CONSTANT)
    Q_PROPERTY(QColor controlColor READ controlColor CONSTANT)
    Q_PROPERTY(QColor controlInActive READ controlInActive CONSTANT)
    Q_PROPERTY(QColor controlActive READ controlActive CONSTANT)
    Q_PROPERTY(QColor foreground READ foreground CONSTANT)
    Q_PROPERTY(QColor foregroundInActive READ foregroundInActive CONSTANT)
    Q_PROPERTY(QColor foregroundActive READ foregroundActive CONSTANT)

public:
    explicit CxStyle(QObject *parent = nullptr);

    int margins() const { return mMargins; }
    int insets() const { return mInsets; }
    int paddings() const { return mPaddings; }
    int spacing() const { return mSpacing; }
    int contentHeight() const { return 25; }

    QColor background() const { return mBgColor; }
    QColor backgroundInActive() const { return QColor("#897946"); }
    QColor backgroundActive() const { return QColor("#568979"); }

    QColor controlColor() const { return QColor("white"); }
    QColor controlActive() const { return QColor("#AEAEAE"); }
    QColor controlInActive() const { return QColor("#AEAEAE"); }

    QColor foreground() const { return mFgColor; }
    QColor foregroundInActive() const { return QColor("#897946"); }
    QColor foregroundActive() const { return QColor("#568979"); }

private:
    int mMargins{8};
    int mInsets{8};
    int mPaddings{4};
    int mSpacing{2};

    QColor mBgColor{"grey"};
    QColor mFgColor{"white"};
};

#endif // CXSTYLE_H
