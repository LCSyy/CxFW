import QtQuick 2.15

Rectangle {
    id: mask
    color: "#897646"
    opacity: 0.6
    visible: false

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
        visible = false;
    }

    Timer {
        id: timer
        repeat: false
        triggeredOnStart:  false
        running: false

        onTriggered: {
            mask.visible = true
        }
    }
}

