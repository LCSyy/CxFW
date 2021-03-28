import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import CxFw.CxStyle 0.1

T.ToolBar {
    id: control

    property int radiusTop: 0
    property int radiusBottom: 0

    implicitWidth: implicitBackgroundWidth
    implicitHeight: implicitBackgroundHeight

    Component.onCompleted: {
        console.log(implicitContentHeight+topPadding+bottomPadding)
    }

    background: Rectangle {
        radius: control.radiusTop
        implicitWidth: control.parent.width
        implicitHeight: 25 + 4 + 4
        color: "grey"

        Rectangle {
            anchors.bottom: parent !== undefined ? parent.bottom : undefined
            anchors.bottomMargin: 0
            width: parent.width
            height: parent.height - 4
            color: "grey"
            radius: control.radiusBottom
        }
    }
}
