import QtQuick 2.15
import QtQuick.Controls 2.15 as Control

import CxQuick 0.1

Control.Button {
    id: button

    leftPadding: BoxTheme.leftPadding
    rightPadding: BoxTheme.rightPadding
    topPadding: BoxTheme.topPadding
    bottomPadding: BoxTheme.bottomPadding

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    background: Rectangle {
        radius: 2
        implicitWidth: 30
        implicitHeight: 25
        color: button.down ? BoxTheme.backgroundFocus : BoxTheme.backgroundInActive
    }

    contentItem: Text {
        text: button.text
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
    }
}
