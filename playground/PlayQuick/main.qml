import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: app
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    ListView {
        id: listView
        anchors.fill: parent
        model: 10
        delegate: Item {
            id: item
            width: 200
            height: 80
            property Rectangle innerItem: rect

            DropArea {
                anchors.fill: parent
            }

            Rectangle {
                id: rect
                width: 200
                height: 80
                anchors.centerIn: parent
                color: Qt.rgba(Math.random(),Math.random(),Math.random(),1.0)
                property Item oldParent: item

                PropertyAnimation on y { duration: 1000; easing.type: Easing.InOutQuad }
            }
        }

        MouseArea {
            anchors.fill: parent
            drag.axis: Drag.YAxis

            onPressed: {
                var item = listView.itemAt(mouse.x,mouse.y)
                if (item !== null && item.innerItem !== undefined) {
                    var innerItem = item.innerItem
                    const p = innerItem.mapToItem(listView,innerItem.x,innerItem.y)
                    innerItem.anchors.centerIn = undefined
                    innerItem.parent = listView
                    innerItem.x = p.x
                    innerItem.y = p.y
                    drag.target = innerItem
                    innerItem.Drag.active = true
                }
            }

            onReleased: {
                var innerItem = drag.target
                if (innerItem !== null) {
                    if (innerItem.Drag.target !== null) {
                        var otherItem = innerItem.Drag.target.parent.innerItem
                        otherItem.parent = innerItem.oldParent
                        otherItem.oldParent = otherItem.parent

                        innerItem.oldParent.innerItem = otherItem

                        innerItem.parent = innerItem.Drag.target.parent
                        innerItem.oldParent = innerItem.parent

                        innerItem.anchors.centerIn = innerItem.parent
                        innerItem.parent.innerItem = innerItem
                    } else {
                        innerItem.parent = innerItem.oldParent
                        innerItem.anchors.centerIn = drag.target.oldParent
                    }
                    innerItem.Drag.active = false
                }
            }
        }
    }
}
