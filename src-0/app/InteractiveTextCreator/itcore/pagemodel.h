#ifndef PAGEMODEL_H
#define PAGEMODEL_H

#include "itcore_global.h"
#include <QAbstractItemModel>

class ITCORE_EXPORT PageModel: public QAbstractItemModel
{
    Q_OBJECT
public:
    explicit PageModel(QObject *parent = nullptr);
};

#endif // PAGEMODEL_H
