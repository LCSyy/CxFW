import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import CxQuick 0.1

T.Button {
    id: button

    leftInset: 0
    topInset: 0
    rightInset: 0
    bottomInset: 0

    leftPadding: Theme.baseMargin
    rightPadding: Theme.baseMargin
    topPadding: Theme.baseMargin
    bottomPadding: Theme.baseMargin

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    background: Rectangle {
        radius: 2
        implicitWidth: 30
        implicitHeight: 25
        color: button.pressed ? Theme.bgNormalColor : "#e2e1e4"
    }

    contentItem: Text {
        text: button.text
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
    }
}
