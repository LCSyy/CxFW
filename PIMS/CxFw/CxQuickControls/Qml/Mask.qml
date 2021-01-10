import QtQuick 2.15

Rectangle {
    id: mask
    color: "#74787a"
    opacity: 0.6
    visible: false

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

    Text {
        anchors.centerIn: parent
        text: "Loading ..."
        font.pointSize: 18
        font.bold: true
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

