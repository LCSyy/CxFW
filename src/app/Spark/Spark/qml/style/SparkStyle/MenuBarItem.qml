import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Templates 2.12 as T

T.MenuBarItem {
    id: menuBarItem

    implicitWidth: 40
    implicitHeight: 25

    contentItem: Text {
        text: menuBarItem.text
        font: menuBarItem.font
        // opacity: enabled ? 1.0 : 0.3
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 40
        implicitHeight: 25
        opacity: enabled ? 1 : 0.3
        color: menuBarItem.highlighted ? "#669BBB" : "transparent"
    }
}
