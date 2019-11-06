#ifndef COLORTOOLWIDGET_H
#define COLORTOOLWIDGET_H

#include <QWidget>

QT_BEGIN_NAMESPACE
class QLineEdit;
class QPushButton;
QT_END_NAMESPACE

class ColorToolWidget : public QWidget
{
    Q_OBJECT
public:
    explicit ColorToolWidget(QWidget *parent = nullptr);

private slots:
    void onColorFieldEdited(const QString &text);
    void onSnapBtnClicked();

private:
    QWidget *mColorWgt {nullptr};
    QLineEdit *mShapeField {nullptr};
    QLineEdit *mRgbField {nullptr};
    QLineEdit *mRgbdField {nullptr};

    QPushButton *mSnapBtn {nullptr};
    QPushButton *mImgBtn {nullptr};
};

#endif // COLORTOOLWIDGET_H
