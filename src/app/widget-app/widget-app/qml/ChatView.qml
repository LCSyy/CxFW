import QtQuick 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.12
import CxIM 1.0

import "." as CxQml

Item {
    id: chatPage

    property var lastMsgTime: undefined

    Component {
        id: chatItem
        CxQml.ChatItem {}
    }

    Component {
        id: dtItem
        Text {
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
        }
    }

    SplitView {
        anchors.fill: parent
        anchors.bottomMargin: sendBtn.height + 20
        orientation: Qt.Vertical

        Rectangle {
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            color: "#F5F5F5"

            ListView {
                id: chatList
                anchors.fill: parent
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                model: ListModel { id: msgModel }

                CxTextMetrics { id: textMetrics }

                delegate: Item {
                    width: parent.width

                    Component.onCompleted:{
                        var obj = undefined;
                        if(model.user !== "dt") {
                            obj = chatItem.createObject(this,{
                                                            width: Qt.binding(function(){ return width; }),
                                                            who: model.me,
                                                            message: model.msg,
                                                            textRect: Qt.binding(function() {
                                                                return textMetrics.boundingRect(
                                                                                      Qt.rect(0,0,width-140,100),
                                                                                      model.msg)
                                                            })
                                                        })
                        } else {
                           obj = dtItem.createObject(this,{width: Qt.binding(function(){ return width; }), height: 30, text: model.dt})
                        }
                        height = obj.height
                    }
                }
            }
        }

        ColumnLayout {
            SplitView.fillWidth: true
            SplitView.preferredHeight: 100
            SplitView.minimumHeight: 100
            spacing: 0
            Row {
                Layout.fillWidth: true
                height: 20
                spacing: 2
                Button {
                    width: 50; height: 20;text: "emoji"
                }
                Button {
                    width: 50; height: 20;text: "gif"
                }
                Button {
                    width: 50; height: 20;text: "shot"
                }
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                TextArea {
                    id: msgEdit
                    wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                }
            }
        }
    }

    Button {
        id: sendBtn
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        width: 100
        height: 30
        text: "send"
        onClicked: {
            const msg = msgEdit.text
            if(msg !== '') {
                var duration = 0;
                const dt = Utils.now();

                if(chatPage.lastMsgTime === undefined) {
                    chatPage.lastMsgTime = dt;
                } else {
                    duration = Utils.timeDurationSeconds(chatPage.lastMsgTime,dt);
                }

                if(duration > 60) {
                    msgModel.append({"me":false,"user":"dt","msg":"","dt":Utils.dateTime2Str(dt)});
                    chatPage.lastMsgTime = dt;
                }

                const rn = Math.random();
                if(rn <= 0.59) {
                    msgModel.append({"me":true,"user":"Ll","msg":msg,"dt":Utils.dateTime2Str(dt)});
                } else {
                    msgModel.append({"me":false,"user":"Ll","msg":msg,"dt":Utils.dateTime2Str(dt)});
                }

                msgEdit.clear();
                chatList.currentIndex = msgModel.count - 1
            }
        }

        Shortcut {
            enabled: msgEdit.focus
            sequence: "Ctrl+Return"
            onActivated: {
                sendBtn.clicked()
            }
        }
    }
}
