import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Universe 0.1
import "../qml" as Universe
import "../qml/AppConfigs.js" as Config
import "../qml/CxFw.js" as CxFw

Pane {
    id: pane
    padding: 0
    topInset: 0
    bottomInset: 0
    leftInset: 0
    rightInset: 0
    background: Rectangle { color: "white" }

    QtObject {
        id: theme
        readonly property int radius: 4
        readonly property int padding: 16
        readonly property int spacing: 16
        readonly property int bodyContentPointSize: Qt.application.font.pointSize + 2
        readonly property color background: "#ECECEC"
        readonly property color foreground: "#FAFAFA"
        readonly property color blockBorder: "#AAA"
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

    ColumnLayout {
        anchors.fill: parent
        spacing: 8

        ListView {
            id: msgView
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: theme.spacing
            model: msgsModel

            delegate: MessageItem {
                anchors.right: parent === null ? undefined : parent.right
                text: model.content
                fontSize: theme.bodyContentPointSize
                textWidth: msgView.width
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
            Layout.minimumHeight: msgBlock.height + 16
            color: "#baccd9"
            RowLayout {
                id: msgBlock
                anchors.margins: 0
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 8
                anchors.rightMargin: 8

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
