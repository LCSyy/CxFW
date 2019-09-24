import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    ListView {
        id: _listView
        anchors.fill: parent
        boundsBehavior: Flickable.StopAtBounds

        model: ListModel {
            ListElement { text: "Dashboard" }
            ListElement { text: "Banking" }
            ListElement { text: "Sales" }
            ListElement { text: "Expenses" }
        }
        delegate: Rectangle {
            width: parent.width
            height: 30
            color: ListView.isCurrentItem ? '#505050' : '#e5e5e5'
            Text {
                anchors.centerIn: parent
                text: model.text
                color: parent.ListView.isCurrentItem ? '#e5e5e5' : 'black'
            }
        }

        // MouseArea {
        //     anchors.fill: parent
        //     onClicked: {
        //         var item = _listView.itemAt(mouse.x,mouse.y)
        //         if(item !== null) {
        //
        //         }
        //     }
        // }
    }
}
