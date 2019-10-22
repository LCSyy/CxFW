import QtQuick 2.12
import QtQuick.Templates 2.12 as T
import QtGraphicalEffects 1.12
import SilenceStyle 1.0

T.Button {

    id: _btn

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                                  implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentWidth + topPadding + bottomPadding)

    background: Rectangle {
        id: _bg

        property string oldState: ""

        color: Silence.focusBackground
        state: {
            oldState = state;
            return _btn.down ? "click" : _btn.hovered ? "hover" : "normal"
        }

        states: [
            State {
                name: "normal"
                PropertyChanges {
                    target: _bg
                    implicitWidth: 100
                    implicitHeight: 30
                    radius: 5
                }
            },
            State {
                name: "hover"
                PropertyChanges {
                    target: _bg
                    implicitWidth: 103
                    implicitHeight: 33
                    radius: 7
                }
            },
            State {
                name: "click"
                PropertyChanges {
                    target: _bg
                    implicitWidth: 95
                    implicitHeight: 25
                    radius: 4
                }
            }
        ]

        transitions: Transition {
            ParallelAnimation {
                NumberAnimation { properties: "implicitWidth"; easing.type: Easing.InOutQuad;
                    duration: _bg.durationFunc()
                }
                NumberAnimation { properties: "implicitHeight"; easing.type: Easing.InOutQuad;
                    duration: _bg.durationFunc()
                }
                NumberAnimation { properties: "radius"; easing.type: Easing.InOutQuad;
                    duration: _bg.durationFunc()
                }
            }
        }

        layer.enabled: true
        layer.effect: DropShadow {
            transparentBorder: true
            horizontalOffset: 4
            verticalOffset: 4
        }

        function durationFunc() {
            if(oldState === "hover" && state === "click"
                    || oldState === "click" && state === "hover") {
                return 80;
            } else {
                return 100;
            }
        }
    }

    contentItem: Text {
        anchors.fill: parent
        text: parent.text
        color: Silence.foreground
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
    }
}

