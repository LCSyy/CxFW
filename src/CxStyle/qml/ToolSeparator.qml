import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import CxFw.CxStyle 0.1

T.ToolSeparator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)

    padding: 0

    leftInset: 4
    rightInset: 4
    topInset: 2
    bottomInset: 2

    background: Rectangle {
        implicitWidth: 1
        implicitHeight: 25
        color: "grey"
    }
}
