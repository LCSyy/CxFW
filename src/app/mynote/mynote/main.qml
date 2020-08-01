import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("New")
            }
            MenuItem {
                text: qsTr("Open")
            }
            MenuSeparator {}
            MenuItem {
                text: qsTr("Save all")
            }
            MenuSeparator {}
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: qsTr("Help")
            MenuItem {
                text: qsTr("About")
            }
        }
    }

    TextArea {
        anchors.fill: parent
    }
}
