import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Pixel Editor")
    menuBar: MenuBar {
        implicitHeight: 25
        Menu {
            title: qsTr("File(&F)")
            implicitHeight: parent.height
        }
    }
}
