import QtQuick 2.15
import CxQuick 0.1 as AppType

Rectangle {
    width: parent.width
    radius: 4
    height: AppType.Theme.toolBarHeight
    color: AppType.Theme.bgNormalColor

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        width: parent.width
        height: parent.height - 4
        color: AppType.Theme.bgNormalColor
    }
}

