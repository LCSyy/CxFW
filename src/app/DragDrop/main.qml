import QtQuick 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: app
    width: 640
    height: 480
    visible: true
    title: qsTr("Scroll")

    Rectangle {
        anchors.centerIn: parent
        width: 100; height: 100
        color: drop.containsDrag ? "#894656" : "grey"

        DropArea {
            id: drop
            anchors.fill: parent
        }
    }


    ListView {
        id: factory
        anchors.fill: parent

        model: 10
        delegate: Item {
            width: 50; height: 50
            property Rectangle nestItem: rect
            DropArea {
                anchors.fill: parent
                Rectangle {
                    id: rect
                    width: 50; height: 50
                    color: "#7889ac"
                    border.width: 2
                    border.color: "#AB8979"
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: undefined
//            drag.minimumX: 0
//            drag.maximumX: app.width
            drag.minimumY: 0
            drag.maximumY: app.height - 50
            drag.axis: Drag.YAxis

            onPressed: {
                for (var i = 0; i < factory.count; ++i) {
                    var item = factory.itemAtIndex(i)
                    const p = mapToItem(item,mouse.x,mouse.y)
                    if (item.contains(p)) {
                        console.log('drag')
                        drag.target = item.nestItem
                        item.nestItem.Drag.active = true
//                        item.nestItem.parent = factory
                        break
                    }
                }
            }

            onReleased: {
                if (drag.target || null !== null) {
                    drag.target.Drag.active = false
                }
                drag.target = undefined
            }
        }
    }
}
