import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import CxQuick 0.1

T.ToolBar {
    id: control

    implicitWidth: implicitBackgroundWidth
    implicitHeight: implicitBackgroundHeight

    background: Rectangle {
        radius: 4
        implicitWidth: control.parent.width
        implicitHeight: Theme.toolBarHeight
        color: Theme.bgNormalColor

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            width: parent.width
            height: parent.height - 4
            color: Theme.bgNormalColor
        }
    }
}
