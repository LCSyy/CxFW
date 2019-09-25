import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import SilenceStyle 1.0 as S

T.Button {

    id: _btn

    implicitWidth: 100
    implicitHeight: 30

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 30
        color: _btn.down ? "#505050" : "#e5e5e5"
    }

    contentItem: Text {
        anchors.fill: parent
        text: parent.text
        color: _btn.down ? "#e5e5e5" : "black"
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
    }
}

