import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import "js/moment.js" as Moment

Window {
    width: 300
    height: 360
    minimumWidth: 300
    maximumWidth: 300
    minimumHeight: 360
    maximumHeight: 360
    visible: true
    title: qsTr("Hello World")
    color: "#868686"

    Timer {
        id: timer
        interval: 1000
        repeat: true

        property int times: 25 * 60 * 1000 // default 25 min

        onTriggered: {
            label.text = moment(label.text,'mm:ss').subtract(1,'seconds').format('mm:ss')

            times -= 1
            if (times === 0) {
                stop()
            }
        }
    }


    Rectangle {
        id: clock
        anchors.centerIn: parent
        width: 200
        height: 200
        radius: 100
        color: "#A84653"

        Text {
            id: label
            text: '25:00'
            anchors.centerIn: parent
            font.pointSize: 40
            font.bold: true
            color: "white"
        }
    }

    Button {
        anchors.horizontalCenter: clock.horizontalCenter
        anchors.top:  clock.bottom
        anchors.topMargin: 16

        text: timer.running ? qsTr("Stop") : qsTr("Start")
        onClicked: {
            timer.running = !timer.running
        }
    }
}

