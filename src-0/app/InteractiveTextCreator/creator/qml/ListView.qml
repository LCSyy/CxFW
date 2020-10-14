import QtQuick 2.15

ListView {
    id: listView

    signal itemClicked(int idx)

    MouseArea {
        anchors.fill: parent

        property point pressPos: Qt.point(0,0)
        onPressed: {
            pressPos = Qt.point(mouse.x,mouse.y)
        }
        onReleased: {
            if (Qt.point(mouse.x,mouse.y) === pressPos) {
                const viewPos = mapToItem(listView,mouse.x,mouse.y)
                const index = listView.indexAt(mouse.x+listView.contentX,mouse.y+listView.contentY)
                listView.itemClicked(index)
            }
        }
    }
}
