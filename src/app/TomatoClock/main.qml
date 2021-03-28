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
    title: qsTr("Tomato Clock")
    color: "#868686"

    QtObject {
        id: theme

        readonly property int fontPointSize: 36
        readonly property int itemMargin: 16
    }

    StateGroup {
        id: clockStates

        Component.onCompleted: {
            clockStates.state = 'stop'
        }

        states: [
            State {
                name: 'stop'
                PropertyChanges {
                    target: timer
                    restoreEntryValues: false
                    running: false
                }

                PropertyChanges {
                    target: btn
                    restoreEntryValues: false
                    text: qsTr("Start")
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
                    text: qsTr('Stop')
                }
            }
        ]
    }

    Timer {
        id: timer
        interval: 1000
        repeat: true

        onTriggered: {
            if (clockSwitch.visualPosition === 0.0) {
                 clockBoard.tickDown()
            } else {
                clockBoard.tickUp()
            }
        }
    }

    Switch {
        id: clockSwitch
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.rightMargin: theme.itemMargin
        anchors.topMargin: theme.itemMargin
        text: visualPosition === 0.0 ? qsTr('Down') : qsTr('Up')
    }

    Button {
        id: btn

        anchors.horizontalCenter: clockBoard.horizontalCenter
        anchors.top:  clockBoard.bottom
        anchors.topMargin: 16

        onClicked: {
            if (clockStates.state === 'stop') {
                clockStates.state = 'running'
            } else {
                clockStates.state = 'stop'
            }
        }
    }

    Grid {
        id: clockBoard
        anchors.centerIn: parent
        columns: 5
        verticalItemAlignment: Qt.AlignVCenter
        horizontalItemAlignment: Qt.AlignHCenter

        function times() {
            return _.padStart(hours.currentIndex,2,'0') +
                    ':' + _.padStart(minutes.currentIndex) +
                    ':' + _.padStart(seconds.currentIndex,2,'0')
        }

        function tickDown() {
            if (seconds.currentIndex > 0) {
                seconds.currentIndex -= 1
            } else {
                seconds.currentIndex = seconds.count - 1

                if (minutes.currentIndex > 0) {
                    minutes.currentIndex -= 1
                } else {
                    minutes.currentIndex = minutes.count - 1

                    if (hours.currentIndex > 0) {
                        hours.currentIndex -= 1
                    } else {
                        hours.currentIndex = hours.count - 1
                    }
                }
            }
        }

        function tickUp() {
            if (seconds.currentIndex < seconds.count - 1) {
                seconds.currentIndex += 1
            } else {
                seconds.currentIndex = 0

                if (minutes.currentIndex < minutes.count - 1) {
                    minutes.currentIndex += 1
                } else {
                    minutes.currentIndex = 0

                    if (hours.currentIndex < hours.count - 1) {
                        hours.currentIndex += 1
                    }
                }
            }
        }

        Tumbler {
            id: hours
            visibleItemCount: 3
            model: 24
            delegate: Text {
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                text: _.padStart(index,2,'0')
                font.pointSize: theme.fontPointSize
                font.bold: true
                color: 'white'
                opacity:  1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            }
        }
        Text {
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
            text: ":"
            font.pointSize: theme.fontPointSize
            font.bold: true
            color: 'white'
        }
        Tumbler {
            id: minutes
            visibleItemCount: 3
            model: 60
            delegate: Text {
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                text: _.padStart(index,2,'0')
                font.pointSize: theme.fontPointSize
                font.bold: true
                color: 'white'
                opacity:  1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            }
        }
        Text {
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
            text: ":"
            font.pointSize: theme.fontPointSize
            font.bold: true
            color: 'white'
        }
        Tumbler {
            id: seconds
            visibleItemCount: 3
            model: 60
            delegate: Text {
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
                text: _.padStart(index,2,'0')
                font.pointSize: theme.fontPointSize
                font.bold: true
                color: 'white'
                opacity:  1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
            }
        }
    }
}

