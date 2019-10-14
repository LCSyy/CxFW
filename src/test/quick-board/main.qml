import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "./qml" as Ui

Window {
    id: _app
    visible: true
    width: 900
    height: 640
    title: qsTr("Hello World")

    Rectangle {
        id: _headerItem
        width: parent.width
        height: 60
    }

    ListView {
        id: _listView
        x:0; y: _headerItem.height
        width: 150; height: parent.height - _headerItem.height
        boundsBehavior: Flickable.StopAtBounds
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

        model: ListModel {
            ListElement { moduleName: "dash_board"; url: "qrc:/modules/Dashboard/Dashboard.qml";  text: "Dashboard"; pageColor: "red" }
            ListElement { moduleName: "pass_word"; url: "qrc:/modules/Password/Password.qml"; text: "Password"; pageColor: "green" }
            ListElement { moduleName: "image_viewer"; url: "qrc:/modules/ImageViewer/ImageViewer.qml"; text: "Image Viewer"; pageColor: "#123456" }
        }

        onCurrentIndexChanged: {
            if(currentIndex < 0) {
                _headerItem.color = "#505050"
                return;
            }

            const module = model.get(currentIndex);
            if(module.url !== "") {
                // _bodyLayout.loadComponent(module.url, module.moduleName)
                // ... _bodyItem.addItem()
            }

            _headerItem.color = module.pageColor
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                var idx = _listView.indexAt(mouse.x,mouse.y);
                if(idx !== -1) { _listView.currentIndex = idx; }
            }

            // onDoubleClicked: {
            //     const module = _listView.model.get(_listView.currentIndex)
            //     if(module !== undefined && module.moduleName !== "") {
            //         // _bodyLayout.removeComponent(module.moduleName)
            //         _listView.currentIndex = -1
            //     }
            // }
        }
    }

    /*
    StackLayout {
        id: _bodyLayout
        x: _listView.width
        y: _headerItem.height
        width: parent.width - _listView.width
        height: parent.height - _headerItem.height

        function loadComponent(url, moduleName) {
            for(const idx in children) {
                if(children[idx].moduleName === moduleName) {
                    currentIndex = idx;
                    return;
                }
            }
            var component = Qt.createComponent(url);
            if (component.status === Component.Ready) {
                component.createObject(_bodyLayout,{"moduleName":moduleName});
            } else if(component.status === Component.Error) {
                console.log("create error:", component.errorString())
            }
        }

        function removeComponent(moduleName) {
            for(const idx in children) {
                var item = children[idx];
                if(item.moduleName === moduleName) {
                    item.destroy();
                    break;
                }
            }
        }
    }
    */

    Ui.ItemSwitcher {
        id: _bodyItem
        x: _listView.width
        y: _headerItem.height
        width: parent.width - _listView.width
        height: parent.height - _headerItem.height
    }
}
