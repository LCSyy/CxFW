import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Universe 0.1
import "../qml" as Universe
import "../qml/AppConfigs.js" as Config
import "../qml/CxFw.js" as CxFw
import "../qml/BoxTheme.js" as BoxTheme

Pane {
    id: pane
    padding: 0
    background: Rectangle { color: "white" }

    CxListModel {
        id: contactsModel
        roleNames: ["avatar", "name","msgBrief"]

        Component.onCompleted: update();

        function update() {
            contactsModel.append({avatar: "#897946", name: "Chat Bot", msgBrief: "Chat Bot"})
            contactsModel.append({avatar: "#ABCDAB", name: "HeMengling", msgBrief: "He Mengling"})
//            CxNetwork.get(URLs.service("fragments").url(""),  Config.basicAuth(), (resp)=>{
//                              try {
//                                  msgsModel.clear();
//                                  const reply = JSON.parse(resp);
//                                  const body = reply.body || [];
//                                  for (var i in body) {
//                                    msgsModel.append(body[i]);
//                                  }
//                              } catch(e) {
//                                  console.log(e.toString());
//                              }
//                              msgView.positionViewAtEnd()
//                          })
        }
    }

    CxListModel {
        id: msgsModel
        roleNames: ["id","content","created_at"]

        Component.onCompleted: update();

        function update() {
            CxNetwork.get(URLs.service("fragments").url(""),  Config.basicAuth(), (resp)=>{
                              try {
                                  msgsModel.clear();
                                  const reply = JSON.parse(resp);
                                  const body = reply.body || [];
                                  for (var i in body) {
                                    msgsModel.append(body[i]);
                                  }
                              } catch(e) {
                                  console.log(e.toString());
                              }
                              msgView.positionViewAtEnd()
                          })
        }

        function pushMessage(content) {
            const data = {
                id: 0,
                content: content,
                created_at: null,
            };
            CxNetwork.post(URLs.service("fragments").url(""), Config.basicAuth(), data, (resp)=>{
                               try {
                                   const reply = JSON.parse(resp);
                                   const body = reply.body || null;
                                   if (body !== null) {
                                       msgsModel.append(body);
                                   }
                               } catch(e) {
                                   console.log(e.toString());
                               }
                               msgView.positionViewAtEnd()
                           })
        }
    }

    SplitView {
        anchors.fill: parent

        ColumnLayout {
            SplitView.minimumWidth: 200
            SplitView.maximumWidth: 300
            SplitView.fillHeight: true
            ListView{
                id: contactsView
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: contactsModel

                delegate: contactComponent
            }
        }

        ColumnLayout {
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            SplitView.minimumWidth: 400
            spacing: BoxTheme.spacing * 4

            ListView {
                id: msgView
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: BoxTheme.spacing * 4
                model: msgsModel

                delegate: MessageItem {
                    anchors.right: parent === null ? undefined : parent.right
                    text: model.content
                    fontSize:  Qt.application.font.pointSize + 2
                    textWidth: Math.min(msgView.width, 540)
                }

                MouseArea {
                    acceptedButtons: Qt.RightButton
                    anchors.fill: parent
                    onClicked: {
                        const idx = CxFw.mouseClickMapToListViewIndex(this, msgView, mouse);
                        msgView.currentIndex = idx;
                        if (idx !== -1) {
                            msgMenu.popup();
                            mouse.accepted = true;
                        }
                    }
                }

                Menu {
                    id: msgMenu

                    Action {
                        text: qsTr("Remove")
                        onTriggered: {
                            const idx = msgView.currentIndex;
                            const m = msgsModel.get(idx) || null;
                            if (m === null) { return; }

                            CxNetwork.del(URLs.service("fragments").url("/"+m.id), Config.basicAuth(), (resp)=>{
                                               try {
                                                  msgsModel.remove(idx);
                                               } catch(e) {
                                                   console.log('[ERROR] Remove tag:'+JSON.stringify(e));
                                               }
                                           })
                        }
                    }
                }

            }

            Rectangle {
                Layout.fillWidth: true
                Layout.minimumHeight: msgBlock.height + BoxTheme.margins * 2
                color: BoxTheme.color8

                RowLayout {
                    id: msgBlock
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin:BoxTheme.leftMargin
                    anchors.rightMargin: BoxTheme.rightMargin
                    spacing: BoxTheme.spacing

                    function sendMsg() {
                        const msg = msgArea.text.trim()
                        if (msg.length > 0) {
                            msgsModel.pushMessage(msg)
                        }
                        msgArea.text = ""
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        contentHeight: Math.min(msgArea.contentHeight + msgArea.topPadding + msgArea.bottomPadding, 300)

                        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                        TextArea {
                            id: msgArea
                            width: parent.width
                            wrapMode: TextEdit.WrapAnywhere
                            background: Rectangle { }
                            Keys.onPressed: {
                                if ((event.key === Qt.Key_Return) && (event.modifiers & Qt.ControlModifier)) {
                                    msgBlock.sendMsg()
                                }
                            }
                        }
                    }

                    Universe.Button {
                        text: qsTr("Send")
                        Layout.alignment: Qt.AlignBottom
                        onClicked: msgBlock.sendMsg()
                    }
                }
            }
        }
    }

    Component {
        id: contactComponent

        Column {
            width: parent.width
            height: bodyRow.height + border.height
            spacing: 0

            Row {
                id: bodyRow
                x: BoxTheme.leftMargin
                width: parent.width
                height: avatar.height + BoxTheme.margins * 2
                spacing: BoxTheme.spacing

                Rectangle {
                    id: avatar
                    width: 40
                    height: 40
                    anchors.verticalCenter: parent.verticalCenter
                    color: model.avatar
                    radius: width / 2
                }

                Column {
                    spacing: BoxTheme.spacing
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        text: model.name
                        font.bold: true
                        font.pointSize: Qt.application.font.pointSize + 2
                    }

                    Text {
                        text: model.msgBrief
                    }
                }
            }

            Rectangle {
                id: border
                width: parent.width
                height: 1
                color: BoxTheme.backgroundDeep
            }
        }
    }

}
