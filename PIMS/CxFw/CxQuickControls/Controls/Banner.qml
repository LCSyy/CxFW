import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: control
    closePolicy: Popup.NoAutoClose

    property alias text: content.text

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 48
        radius: 4
        color: "white"
    }

    contentItem: Text {
        id: content
        font.bold: true
        font.pointSize: 14
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
    }

    function show(msg) {
        showTimer.restart();
        control.text = msg;
        control.visible = true;
    }

    Behavior on x {
        NumberAnimation { duration: 100 }
    }


    Timer {
        id: showTimer
        interval: 2000
        repeat: false
        running: false
        triggeredOnStart: false

        onTriggered: {
            control.visible = false
            control.text = ""
        }
    }
}
