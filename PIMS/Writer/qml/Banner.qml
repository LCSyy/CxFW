import QtQuick 2.15
import QtQuick.Controls 2.15

Popup {
    id: control
    width: 200
    height: 48
    closePolicy: Popup.NoAutoClose

    property alias text: content.text

    background: Rectangle {
        radius: 4
        color: "#E5E5E5"
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

    Timer {
        id: showTimer
        interval: 2000
        repeat: false
        running: false
        triggeredOnStart: false

        onTriggered: {
            control.close()
            control.text = ""
        }
    }
}
