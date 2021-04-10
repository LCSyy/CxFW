import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.12
import App 1.1

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("Hello World")

    Loader {
        anchors.centerIn: parent
        sourceComponent: chatBubbleComponent
    }

    Component {
        id: chatBubbleComponent

        Rectangle {
            id: bubble
            width: 200
            height: 300
            radius: 8
            color: "#89ABCD"
            layer.enabled: true
            layer.effect: Glow {
                radius: 16
                samples: 33
                color: "#e5e5e5"
            }

            TextEdit {
                anchors.fill: parent
                padding: 16
                text: qsTr('各种文字，表情😄，图片，以及链接https://github.com。')
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                selectByMouse: true
                readOnly: true
            }
        }
    }

    // 演示光晕特效
    Component {
        id: glowComponent

        Control {
            id: control
            hoverEnabled: true

            implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                                    implicitContentWidth + leftPadding + rightPadding)
            implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                     implicitContentHeight + topPadding + bottomPadding)

            background: Rectangle {
                implicitWidth: 600
                implicitHeight: 400
                radius: 8
                color: "white"
                clip: true
                layer.enabled: true
                layer.effect: Glow {
                    radius: control.hovered ? 16 : 8
                    samples: control.hovered ? 33 : 17
                    color: "#EAEAEA"
                }
            }

            contentItem: Item {
                Column {
                    anchors.centerIn: parent
                    spacing: 8
                    TextField {
                        id: accountField
                        leftPadding: 20
                        rightPadding: 20
                        background: Rectangle {
                            implicitWidth: 200
                            implicitHeight: 40
                            border.color: accountField.activeFocus ? "grey" : "#e5e5e5"
                            radius: 20
                        }
                    }
                    TextField {
                        id: passwordField
                        leftPadding: 20
                        rightPadding: 20
                        background: Rectangle {
                            implicitWidth: 200
                            implicitHeight: 40
                            border.color: passwordField.activeFocus ? "grey" : "#e5e5e5"
                            radius: 20
                        }
                    }
                    Button {
                        id: loginButton
                        width: parent.width
                        text: "登录"
                        font.pointSize: Qt.application.font.pointSize + 4
                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 40
                            radius: 20
                            color: loginButton.down ? "#d8d8d8" : "#e5e5e5"
                        }
                    }
                }
            }
        }
    }
}
