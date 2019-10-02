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
            ListElement { text: "Dashboard"; moduleName: "dash_board"; pageColor: "red" }
            ListElement { text: "Password"; moduleName: "pass_word"; pageColor: "green" }
            ListElement { text: "Logs"; moduleName: "logs"; pageColor: "blue" }
            ListElement { text: "Image Viewer"; moduleName: "image_viewer"; pageColor: "#123456" }
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
            const module = model.get(currentIndex);
            if(module.moduleName === "dash_board") {
                _bodyLoader.sourceComponent = _dashboard
            } else if(module.moduleName === "pass_word") {
                _bodyLoader.source = "qrc:/modules/Password/Password.qml"
            } else if(module.moduleName === "logs") {
                _bodyLoader.sourceComponent = _logs
            } else if(module.moduleName === "image_viewer") {
                _bodyLoader.source = "qrc:/modules/ImageViewer/ImageViewer.qml"
            }
            _headerItem.color = module.pageColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var idx = _listView.indexAt(mouse.x,mouse.y);
                if(idx !== -1) { _listView.currentIndex = idx; }
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
        }
    }

    Component {
        id: _logs
        Rectangle {
        }
    }
}
