import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import CxQuick 0.1

T.TextField {
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            (contentWidth + leftPadding + rightPadding) > 200 ? 200 : (contentWidth + leftPadding + rightPadding))
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    verticalAlignment: Qt.AlignVCenter
    leftPadding: BoxTheme.leftPadding
    rightPadding: BoxTheme.rightPadding

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: BoxTheme.baseHeight
        border.color: control.activeFocus ? BoxTheme.backgroundFocus : BoxTheme.backgroundInActive
        border.width: 1
    }
}
