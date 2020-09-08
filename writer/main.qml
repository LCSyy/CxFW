import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: app
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    readonly property string bg_depth_color: '#222222'

    TextArea {
        anchors.fill: parent
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 100
            border.color: app.bg_depth_color
            border.width: 1
        }
    }
}
