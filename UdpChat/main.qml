import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import UChat 0.1

ApplicationWindow {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Connections {
        target: UdpChat

        function onMsgReady(msgType, peer, info) {
            if (msgType === 2) { // Info
                replyBox.text = info;
            }
        }
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            Row {
                Layout.fillHeight: true
                Layout.rightMargin: 16
                Label {
                    height: parent.height
                    text: qsTr("Host:")
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                }
                ComboBox {
                    id: hostCombo
                    model: ListModel {
                        id: hostModels
                        ListElement { host: "127.0.0.1" }

                        function update() {
                            hostModels.clear();
                            const hosts = UdpChat.hostAddrs();
                            for (let h of hosts) {
                                hostModels.append({host:h});
                            }
                            hostCombo.currentIndex = 0
                        }

                        Component.onCompleted: update()
                    }
                }
            }

            Row {
                Layout.fillHeight: true
                Layout.rightMargin: 16
                Label {
                    height: parent.height
                    text: qsTr("Subnet Mask:")
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                }

                TextField {
                    id: subnetField
                    text: "192.168.1.1/24"
                    onTextChanged: update()

                    function update() {
                        UdpChat.setSubnet(text);
                        hostModels.update();
                    }

                    Component.onCompleted: update()
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Item {
            SplitView.minimumWidth: 200
            SplitView.preferredWidth: 200
            SplitView.maximumWidth: 300

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 8

                Button {
                    Layout.fillWidth: true
                    text: qsTr("Search friends")
                    onClicked: {
                        UdpChat.sendBroadCast()
                    }
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
            }
        }
        Item {
            SplitView.minimumWidth: 200

            SplitView {
                anchors.fill: parent
                orientation: Qt.Vertical
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    TextEdit {
                        id: msgBox
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.margins: 8
                        Item {
                            Layout.fillWidth: true
                        }
                        Button {
                            text: qsTr("Send")
                            onClicked: {
                                UdpChat.sendMsg("192.168.1.6",msgBox.text.trim())
                            }
                        }
                    }
                }


                TextEdit {
                    id: replyBox
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    readOnly: true
                }
            }
        }
    }
}
