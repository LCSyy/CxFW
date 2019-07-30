import QtQuick 2.12

Item {
    MouseArea {
        anchors.fill: parent
        property point pressPos: '0,0'
        onPressed: {
            pressPos = Qt.point(mouse.x,mouse.y)
        }
        onPositionChanged: {
            parent.x += mouse.x - pressPos.x
            parent.y += mouse.y - pressPos.y
        }
    }
}
