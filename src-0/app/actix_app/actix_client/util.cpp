#include "util.h"
#include <QFontMetricsF>

#include <QDebug>

Util::Util(QObject *parent) : QObject(parent)
{

}

/*!
 * \brief Util::textBoundingRect
 *
 * 用于QML中返回特定大小区域rect中文本的绑定区域。
 * 因为QML中的 TextMetrics 不支持设置区域大小，所以封装此方法。
 *
 * \param rect
 * \param flags
 * \param text
 * \param font
 * \return
 */
QRect Util::textBoundingRect(const QRect &rect, int flags, const QString &text, const QFont &font) const
{
    QFontMetrics metrics(font);
    return metrics.boundingRect(rect,flags | Qt::TextWordWrap,text);
}
