import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import "js/moment.js" as Moment
import "js/lodash.js" as Lodash

ApplicationWindow {
    width: 300
    height: 360
    minimumWidth: 300
    maximumWidth: 300
    minimumHeight: 360
    maximumHeight: 360
    visible: true
    title: qsTr("Hello World")
    color: "#868686"

    Component.onCompleted: {
        clockStates.state = 'stop'
    }

    StateGroup {
        id: clockStates

        states: [
            State {
                name: 'stop'
                PropertyChanges {
                    target: timer
                    restoreEntryValues: false
                    running: false
                    times: 25 * 60
                }

                PropertyChanges {
                    target: btn
                    restoreEntryValues: false
                    text: qsTr("Start")
                }

                PropertyChanges {
                    target: label
                    restoreEntryValues: false
                    text: qsTr('Tomato')
                }
            },
            State {
                name: 'idle'

                PropertyChanges {
                    target: timer
                    restoreEntryValues: false
                    running: false
                }

                PropertyChanges {
                    target: btn
                    restoreEntryValues: false
                    text: qsTr('Start')
                }
            },
            State {
                name: 'running'

                PropertyChanges {
                    target: timer
                    restoreEntryValues: false
                    running: true
                }
                PropertyChanges {
                    target: btn
                    restoreEntryValues: false
                    text: qsTr('Idle')
                }
                PropertyChanges {
                    target: label
                    restoreEntryValues: false
                    text: timer.timeToShow(timer.times)
                }
            }
        ]
    }

    Timer {
        id: timer
        interval: 1000
        repeat: true

        property int times: 0

        function timeToShow(t) {
            const dur = moment.duration(t,'seconds')
            return _.padStart(dur.minutes(),2,'0') + ':' + _.padStart(dur.seconds(),2,'0')
        }

        onTriggered: {
            times -= 1
            label.text = timeToShow(times)
            if (times === 0) {
                clockStates.state = 'stop'
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
            anchors.centerIn: parent
            font.pointSize: 40
            font.bold: true
            color: "white"
        }
    }

    Button {
        id: btn

        anchors.horizontalCenter: clock.horizontalCenter
        anchors.top:  clock.bottom
        anchors.topMargin: 16

        onClicked: {
            if (clockStates.state === 'stop' || clockStates.state === 'idle') {
                clockStates.state = 'running'
            } else {
                clockStates.state = 'idle'
            }
        }
    }

    RoundButton {
        id: resetBtn
        radius: 10

        text: qsTr("R")

        anchors.right: parent.right
        anchors.rightMargin: 16
        anchors.verticalCenter: btn.verticalCenter

        onClicked: {
            clockStates.state = 'stop'
        }
    }
}

