import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import CxQuick 0.1

T.ToolBar {
    id: control

    property int upRadius: 4
    property int bottomRadius: 0

    implicitWidth: implicitBackgroundWidth
    implicitHeight: implicitBackgroundHeight

    Component.onCompleted: {
        console.log(implicitContentHeight+topPadding+bottomPadding)
    }

    background: Rectangle {
        radius: control.upRadius
        implicitWidth: control.parent.width
        implicitHeight: BoxTheme.baseHeight + BoxTheme.topPadding + BoxTheme.bottomPadding
        color: BoxTheme.backgroundFocus

        Rectangle {
            anchors.bottom: parent !== undefined ? parent.bottom : undefined
            anchors.bottomMargin: 0
            width: parent.width
            height: parent.height - 4
            color: BoxTheme.backgroundFocus
            radius: control.bottomRadius
        }
    }
}
