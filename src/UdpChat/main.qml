import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import CxFw.CxQuick 0.1
import UChat 0.1
import "./qml" as UChat

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: qsTr("Hello World")

    Connections {
        target: UdpChat

        function onMsgReady(msgType, peerHost, peerPort, info) {
            console.log('msg:', msgType, 'host:', peerHost, 'port:', peerPort);
            switch (msgType) {
            case 1: // Hello
                replyBox.text += '<p><span style="color:red;">{0}:</span> {1}</p>'.replace("{0}", peerHost).replace('{1}',info);
                break;
            case 2: // Bye
                break;
            case 3: // Pending
                break;
            case 4: // Search
                contactsModel.clear();
                contactsModel.append({peerHost:peerHost, peerPort: peerPort});
                break;
            }
        }
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            RowLayout {
                Layout.fillHeight: true
                Layout.rightMargin: 16
                Label {
                    Layout.alignment: Qt.AlignVCenter
                    height: parent.height
                    text: qsTr("Host:")
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                }
                ComboBox {
                    id: hostCombo

                    Layout.alignment: Qt.AlignVCenter
                    onCurrentIndexChanged: {
                        const info = hostModels.get(currentIndex);
                        if (info) {
                            console.log('host list - current combo changed', JSON.stringify(info));
                            UdpChat.setHost(info.host);
                        }
                    }

                    model: ListModel {
                        id: hostModels
                        ListElement { host: "127.0.0.1" }

                        function update() {
                            hostModels.clear();
                            hostCombo.currentIndex = -1;
                            const hosts = UdpChat.hostAddrs();
                            for (let h of hosts) {
                                hostModels.append({host:h});
                            }
                            hostCombo.currentIndex = 0
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillHeight: true
                Layout.rightMargin: 16
                Label {
                    Layout.alignment: Qt.AlignVCenter
                    height: parent.height
                    text: qsTr("Subnet Mask:")
                    verticalAlignment: Qt.AlignVCenter
                    horizontalAlignment: Qt.AlignHCenter
                }

                TextField {
                    Layout.alignment: Qt.AlignVCenter
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
                    id: contacts
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    currentIndex: -1
                    model: ListModel {
                        id: contactsModel
                        ListElement { peerHost: "Nobody"; peerPort: 0 }
                    }
                    delegate: Item {
                        width: contacts.width
                        height: 40
                        Text {
                            anchors.fill: parent
                            text: model.peerHost
                            verticalAlignment: Qt.AlignVCenter
                            // horizontalAlignment: Qt.AlignHCenter
                            color: model.index === contacts.currentIndex ? "#f1939c" : "black"
                            font.bold: model.index === contacts.currentIndex ? true : false
                            font.pointSize: model.index === contacts.currentIndex ? Qt.application.font.pointSize + 2 : Qt.application.font.pointSize
                        }
                        Rectangle {
                            width: parent.width
                            y: 38
                            height: model.index === contacts.currentIndex ? 2 : 1
                            color: model.index === contacts.currentIndex ? "#f1939c" : "grey"
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            const p = mapToItem(contacts, mouse.x, mouse.y);
                            const index = contacts.indexAt(p.x + contacts.contentX, p.y + contacts.contentY);
                            contacts.currentIndex = index;
                        }
                    }
                }
            }
        }
        Item {
            SplitView.minimumWidth: 200

            ColumnLayout {
                anchors.fill: parent
                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ListView {
                        id: msgView
                        anchors.fill: parent
                        boundsBehavior: Flickable.StopAtBounds
                        spacing: 16
                        model: CxListModel {
                            id: msgModel
                            roleNames: ["content"]
                        }
                        delegate: UChat.MsgItem {
                            width: msgView.width
                            color: index % 2 === 0 ? "#ABCDEF" : "white"
                            text: model.content
                        }
                    }
                }

                UChat.SendMsgArea {
                    Layout.fillWidth: true
                    onSendMsg: {
                        const peer = contactsModel.get(contacts.currentIndex) || {};
                        const peerHost = peer.peerHost || "";
                        const peerPort = peer.peerPort || 0;
                        msgModel.append({content: msg});
                        msgView.positionViewAtEnd();
                        UdpChat.sendMsg(peerHost, msg);
                    }
                }
            }
        }
    }
}
