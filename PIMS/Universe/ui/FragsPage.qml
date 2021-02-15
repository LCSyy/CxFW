import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import Universe 0.1
import CxQuick 0.1
import CxQuick.Controls 0.1 as Cx

import "../qml/AppConfigs.js" as Config

Pane {

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    background: Rectangle {
        color: "white"
    }

    property int messageBlockSize: Math.min(width * 0.8, 640)
    property var settingsComponent: Qt.createComponent("qrc:/qml/SettingsPage.qml")

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

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Rectangle {
            SplitView.fillHeight: true
            SplitView.preferredWidth: 200
            SplitView.maximumWidth: 240
            SplitView.minimumWidth: 200
        }

        Column {
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            padding: 4
            topPadding: 16

            ListView {
                id: msgView
                width: parent.width - (parent.leftPadding + parent.rightPadding)
                spacing: theme.spacing
                height: parent.height - (parent.topPadding + parent.bottomPadding) - msgBlock.height
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

            RowLayout {
                id: msgBlock
                width: parent.width - (parent.leftPadding + parent.rightPadding)
                function sendMsg() {
                    const msg = msgArea.text.trim()
                    if (msg.length > 0) {
                        msgsModel.pushMessage(msg)
                    }
                    msgArea.text = ""
                }

                Button {
                    text: qsTr("Settings")
                    Layout.alignment: Qt.AlignBottom
                    onClicked: app.openSettings()
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

                Button {
                    text: qsTr("Send")
                    Layout.alignment: Qt.AlignBottom
                    onClicked: msgBlock.sendMsg()
                }
            }
        }
    }
}
