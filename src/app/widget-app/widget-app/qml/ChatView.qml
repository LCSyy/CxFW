import QtQuick 2.12
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.12
import CxIM 1.0

Item {
    SplitView {
        anchors.fill: parent
        anchors.bottomMargin: sendBtn.height + 20
        orientation: Qt.Vertical

        ListView {
            id: chatList
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            boundsBehavior: Flickable.StopAtBounds
            model: ListModel { id: msgModel }

            CxTextMetrics { id: textMetrics }

            delegate: Item {
                id: chatItem
                width: parent.width
                height: msgBg.height + 20

                Rectangle {
                    id: userIcon
                    x: model.me === true ? parent.width - 40 : 10
                    y: 10
                    width: 30
                    height: 30
                    radius: 15
                    color: model.me === true ? "#185346" : "#91AB56"
                }

                Rectangle {
                    id: msgBg

                    property rect textRect: textMetrics.boundingRect(
                                                Qt.rect(0,0, chatItem.width - 140,100),
                                                model.msg )

                    y: 10
                    radius: 6
                    color: "#789ABC"
                    anchors.left: model.me === true ? undefined : userIcon.right
                    anchors.right: model.me === true ? userIcon.left : undefined
                    anchors.leftMargin: model.me === true ? undefined : 10
                    anchors.rightMargin: model.me === true ? 10 : undefined
                    width: textRect.width + 20
                    height: textRect.height + 20
                    TextEdit {
                        id: msgText
                        anchors.fill: parent
                        padding: 10
                        readOnly: true
                        selectByMouse: true
                        text: model.msg
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        horizontalAlignment: Qt.AlignLeft
                    }
                }
            }
        }

        ColumnLayout {
            SplitView.fillWidth: true
            SplitView.preferredHeight: 100
            SplitView.minimumHeight: 100
            spacing: 0
            RowLayout {
                Layout.fillWidth: true
                height: 20
                spacing: 0
                ToolButton {
                    width: 50
                    height: 20
                    text: 'emoji'
                }
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                TextArea {
                    id: msgEdit
                    wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
                    background: Rectangle {
                        anchors.fill: parent
                        color: msgEdit.activeFocus ? "white" : "#F8F8F8"
                    }
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
                msgModel.append({"me":true,"user":"Ll","msg":msg});
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
