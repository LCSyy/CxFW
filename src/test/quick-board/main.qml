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
        color: "#505050"
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
            if(currentIndex === 0) {
                _bodyLoader.sourceComponent = _dashboard
                _headerItem.color = _bodyLoader.item.relatePageColor
            } else if(currentIndex === 1) {
                _bodyLoader.sourceComponent = _password
            } else if(currentIndex === 2) {
                _bodyLoader.sourceComponent = _logs
            }
            _headerItem.color = _bodyLoader.item.relatePageColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var idx = _listView.indexAt(mouse.x,mouse.y)
                if(idx !== -1) { _listView.currentIndex = idx }
            }
        }
    }

    Loader {
        id: _bodyLoader
        x: _listView.width
        y: _headerItem.height
        width: parent.width - _listView.width
        height: parent.height - _headerItem.height
    }

    Component {
        id: _dashboard
        Rectangle {
            color: "red"
            property color relatePageColor: "#AA1111"

            Component.onDestruction: {
                console.log("destruction red")
            }
        }
    }

    Component {
        id: _password
        Rectangle {
            color: "green"
            property color relatePageColor: "#11AA11"

            Component.onDestruction: {
                console.log("destruction green")
            }
        }
    }

    Component {
        id: _logs
        Rectangle {
            color: "blue"
            property color relatePageColor: "#1111AA"

            Component.onDestruction: {
                console.log("destruction blue")
            }
        }
    }
}
