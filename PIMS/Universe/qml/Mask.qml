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
        if (mask.maskItem !== null) {
            mask.maskItem.enabled = true;
        }
        visible = false;
    }

    body: Item {
        Text {
            anchors.centerIn: parent
            text: "Loading ..."
            font.pointSize: 18
            font.bold: true
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
            mask.visible = true
            if (mask.maskItem !== null) {
                mask.maskItem.enabled = false;
            }
        }
    }
}
