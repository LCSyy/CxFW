#ifndef THEME_H
#define THEME_H

#include <QObject>
#include <QQmlEngine>

class Theme : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int baseMargin READ baseMargin CONSTANT)
    Q_PROPERTY(int contentHeight READ contentHeight CONSTANT)
    Q_PROPERTY(int toolBarHeight READ toolBarHeight CONSTANT)
    Q_PROPERTY(QString bgDeepColor READ bgDeepColor CONSTANT)
    Q_PROPERTY(QString bgNormalColor READ bgNormalColor CONSTANT)
    Q_PROPERTY(QString bgLightColor READ bgLightColor CONSTANT)
    Q_PROPERTY(QString fgDeepColor READ fgDeepColor CONSTANT)
    Q_PROPERTY(QString fgNormalColor READ fgNormalColor CONSTANT)
    Q_PROPERTY(QString fgLightColor READ fgNormalColor CONSTANT)
public:
    explicit Theme(QObject *parent = nullptr): QObject(parent) {}

    int baseMargin() const { return m_baseMargin; }
    int contentHeight() const { return m_contentHeight; }
    int toolBarHeight() const { return m_toolBarHeight; }
    const QString &bgDeepColor() const { return m_bgDeepColor; }
    const QString &bgNormalColor() const { return m_bgNormalColor; }
    const QString &bgLightColor() const { return m_bgLightColor; }
    const QString &fgDeepColor() const { return m_fgDeepColor; }
    const QString &fgNormalColor() const { return m_fgNormalColor; }
    const QString &fgLightColor() const { return m_fgLightColor; }

protected:
    int m_baseMargin{8};
    int m_contentHeight{25};
    int m_toolBarHeight{40};
    QString m_bgDeepColor{"#222"};
    QString m_bgNormalColor{"#aaa"};
    QString m_bgLightColor{"#e2e2e2"};
    QString m_fgDeepColor;
    QString m_fgNormalColor;
    QString m_fgLightColor;
};

// Box
//   Width
//   Height
//   Inset
//   Padding
//   Background
//     Color
//     Border
//       Color
//       Size
//       Radius
//   Content
//     Margin

#endif // THEME_H
