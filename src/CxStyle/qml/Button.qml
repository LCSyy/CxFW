import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import CxFw.CxStyle 0.1

T.Button {
    id: button

    leftPadding: CxStyle.paddings
    rightPadding: CxStyle.paddings
    topPadding: CxStyle.paddings
    bottomPadding: CxStyle.paddings

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    background: Rectangle {
        radius: 2
        implicitWidth: 30
        implicitHeight: 25
        color: button.down ? CxStyle.controlActive : CxStyle.controlColor
    }

    contentItem: Text {
        text: button.text
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
    }
}
