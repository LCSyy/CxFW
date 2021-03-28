import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import CxFw.CxStyle 0.1

T.Menu {
    id: control

    readonly property int fixdWidth: 100

    implicitWidth:  Math.max(implicitBackgroundWidth,implicitContentWidth)
    implicitHeight: Math.max(implicitBackgroundHeight, implicitContentHeight)

    background: Rectangle {
        implicitWidth: control.fixdWidth
        implicitHeight: 25
        color: "white"
        radius: 2
    }

    delegate: MenuItem {
            id: menuItem
            implicitWidth: control.fixdWidth
            implicitHeight: 25

            contentItem: Text {
                leftPadding: menuItem.indicator.width
                rightPadding: menuItem.arrow.width
                text: menuItem.text
                font: menuItem.font
                color: menuItem.highlighted ? "white" : "black"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: control.fixdWidth
                implicitHeight: 25
                opacity: enabled ? 1 : 0.3
                color: menuItem.highlighted ? "grey" : "transparent"
                radius: 2
            }
        }

    contentItem: Column { }
}
