import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import CxFw.CxStyle 0.1

T.TextField {
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            (contentWidth + leftPadding + rightPadding) > 200 ? 200 : (contentWidth + leftPadding + rightPadding))
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    verticalAlignment: Qt.AlignVCenter
    leftPadding: 4
    rightPadding: 4

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 25
        border.color: control.activeFocus ? CxStyle.controlActive : CxStyle.controlInActive
        border.width: control.activeFocus ? 2 : 1
    }
}
