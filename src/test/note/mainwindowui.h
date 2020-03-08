#ifndef MAINWINDOWUI_H
#define MAINWINDOWUI_H


#include <QtGlobal>

QT_BEGIN_NAMESPACE
class QTextEdit;
class QLineEdit;
class QQuickWidget;
QT_END_NAMESPACE

class MainWindow;
class MainWindowUi
{
public:

    void setupUi(MainWindow *wgt);

    QLineEdit *inputField() const { return mInputField; }
    QQuickWidget *quickView() const { return mQuickView; }

private:
    QLineEdit *mInputField {nullptr};
    QQuickWidget *mQuickView {nullptr};
};

#endif // MAINWINDOWUI_H
