#ifndef CXCOLORPICKER_H
#define CXCOLORPICKER_H

#include "cxquick_global.h"
#include <QQuickItem>

class CxColorPickerPrivate;
class CXQUICK_SHARED_EXPORT CxColorPicker : public QQuickItem
{
    Q_OBJECT
public:
    explicit CxColorPicker(QQuickItem *parent=nullptr);
    ~CxColorPicker() override;

public slots:

protected:
    QSGNode *updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *data) override;

private:
    CxColorPickerPrivate *d{nullptr};
};

#endif // CXCOLORPICKER_H
