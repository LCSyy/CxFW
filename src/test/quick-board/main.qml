import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    visible: true
    width: 900
    height: 640
    title: qsTr("Hello World")

    Rectangle {
        id: _headerItem
        width: parent.width
        height: 60
        color: "#404040"
    }

    ListView {
        id: _listView
        x:0; y: _headerItem.height
        width: 150; height: parent.height - _headerItem.height

        boundsBehavior: Flickable.StopAtBounds

        model: ListModel {
            ListElement { text: "Dashboard" }
            ListElement { text: "Password" }
            ListElement { text: "Logs" }
        }

        delegate: Rectangle {
            width: parent.width
            height: 30
            color: ListView.isCurrentItem ? '#505050' : 'white'
            Text {
                anchors.centerIn: parent
                text: model.text
                color: parent.ListView.isCurrentItem ? '#e5e5e5' : 'black'
            }
        }

        onCurrentIndexChanged: {
            // ...
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var idx = _listView.indexAt(mouse.x,mouse.y)
                if(idx !== -1) { _listView.currentIndex = idx }
            }
        }
    }

    Item {
        id: _bodyItem
        x: _listView.width
        y: _headerItem.height
        width: parent.width - _listView.width
        height: parent.height - _headerItem.height
        Text {
            id: _billboard
            anchors.fill: parent
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
            text: "Home"
            font.pointSize: 48
        }
    }
}
