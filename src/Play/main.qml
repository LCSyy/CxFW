import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Button {
        id: control
        anchors.centerIn: parent
        text: qsTr('Hello')
        hoverEnabled: true
        icon.source: "qrc:/icon/comments.svg"
        // display: AbstractButton.IconOnly
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 40
            radius: 8
            color: control.hovered || control.down ? control.down ? "grey" : "#AEAEAE" : "#EAEAEA"
        }
    }
}
