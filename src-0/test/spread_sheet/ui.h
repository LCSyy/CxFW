#ifndef UI_H
#define UI_H

#include <QtGlobal>

QT_BEGIN_NAMESPACE
class QTableView;
QT_END_NAMESPACE

class MainWindow;

namespace widget_ui {

struct Ui {
    QTableView *mTableView {nullptr};

    void setupUi(MainWindow *wgt);
};

}


#endif // UI_H
