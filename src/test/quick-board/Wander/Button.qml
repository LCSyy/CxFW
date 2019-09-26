import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import WanderStyle 1.0

T.Button {

    id: _btn

    implicitWidth: 100
    implicitHeight: 30

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 30
        color: _btn.down ? Wander.focusBackground : Wander.background
    }

    contentItem: Text {
        anchors.fill: parent
        text: parent.text
        color: _btn.down ? Wander.focusForeground : Wander.foreground
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
    }
}

