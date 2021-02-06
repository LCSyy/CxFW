import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import CxQuick 0.1
import CxQuick.Controls 0.1 as Cx
import CxQuick.App 0.1 as CxApp

import "./qml" as App
import "./qml/Config.js" as Config

ApplicationWindow {
    id: app
    width: 640
    height: 480
    visible: true
    title: qsTr("Fragments")
    color: theme.background

    property int messageBlockSize: Math.min(width * 0.8, 640)
    property var settingsComponent: Qt.createComponent("qrc:/qml/SettingsPage.qml")

    function openSettings() {
        var incubator = settingsComponent.incubateObject(app.contentItem);
        if (incubator.status !== Component.Ready) {
             incubator.onStatusChanged = function(status) {
                 if (status === Component.Ready) {
                     incubator.object.open();
                 }
             }
         } else {
            incubator.object.open();
         }
    }

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


    // Shortcut {
    //     sequence: "Ctrl+Return"
    //     onActivated: msgBlock.sendMsg()
    // }

    CxListModel {
        id: msgsModel
        roleNames: ["id","content","created_at"]

        Component.onCompleted: update();

        function update() {
            msgsModel.clear();
            CxNetwork.get(URLs.url(""),  Config.basicAuth(), (resp)=>{
                              try {
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
            CxNetwork.post(URLs.url(""), Config.basicAuth(), data, (resp)=>{
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

    ListView {
        id: msgView
        spacing: theme.spacing
        anchors.top: parent.top
        anchors.bottom: msgBlock.top
        anchors.margins: 16
        width: app.messageBlockSize + theme.padding * 2
        anchors.horizontalCenter: parent.horizontalCenter
        model: msgsModel

        delegate: App.MessageItem {
            anchors.right: parent === null ? undefined : parent.right
            anchors.rightMargin: theme.padding
            text: model.content
            fontSize: theme.bodyContentPointSize
            textWidth: app.messageBlockSize
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
                    const m = msgsModel.get(msgView.currentIndex) || null;
                    if (m === null) { return; }

                    CxNetwork.del(URLs.url("/"+m.id), Config.basicAuth(), (resp)=>{
                                       try {
                                           msgsModel.update();
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
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 4

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
