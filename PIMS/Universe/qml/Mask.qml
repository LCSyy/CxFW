import QtQuick.Window 2.15
import QtQuick 2.15
import QtQuick.Controls 2.15

import "." as Universe

Universe.Popup {
    id: popup
    width: 300
    height: 200
    destroyOnHide: false
    modal: true
    closePolicy: Popup.NoAutoClose

    property Item maskItem: null
    property alias msg: label.text

    function showMask(time) { // milliseconds
        if (time === undefined) {
            timer.interval = 1000; // default
        } else {
            timer.interval = time <= 0 ? 100 : time;
        }
        timer.start();
    }

    function hideMask() {
        timer.stop();
        if (popup.maskItem !== null) {
            popup.maskItem.enabled = true;
        }
        visible = false;
    }

    body: Item {
        Text {
            id: label
            anchors.centerIn: parent
            font.pointSize: 18
            font.bold: true
            text: qsTr("Loading ...")
        }

        Button {
            text: qsTr("Cancel")
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: 16
            onClicked: popup.hideMask()
        }
    }

    Timer {
        id: timer
        repeat: false
        triggeredOnStart:  false
        running: false

        onTriggered: {
            popup.visible = true
            if (popup.maskItem !== null) {
                popup.maskItem.enabled = false;
            }
        }
    }
}
