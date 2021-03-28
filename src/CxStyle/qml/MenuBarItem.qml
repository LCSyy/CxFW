import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import CxFw.CxStyle 0.1

T.MenuBarItem {
    id: control
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    contentItem: Text {
        text: control.text
        font: control.font
        padding: CxStyle.paddings
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 40
        implicitHeight: CxStyle.contentHeight
        color: control.down ? CxStyle.controlActive : CxStyle.controlColor
    }
}
