import QtQuick 2.13
import QtQuick.Templates 2.13 as T

T.Button {
    id: control

    implicitWidth: 100
    implicitHeight: 30

    contentItem: Text {
        text: parent.text
        anchors.fill: parent
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
    }
    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 30
        color: control.hovered ? "#669BBB" : "#447999"
    }
}
