import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import Andy.Model 1.0
import "./qml" as AndyQuick

/*! Ui Spec
  Inner Spacing: 3
  Item Spacing: 6
  Margin: 12
  Background: "#F1F1F1"
  Foreground: "white"
*/
Window {
    visible: true
    width: 320
    height: 580
    maximumWidth: 500
    title: "Snippet Manager"
    color: "#F1F1F1"

    Item {
        id: centralItem
        anchors.fill: parent
        visible: false

        Text {
            width: parent.width
            height: 45
            text: "Snippet Manager"
            font.bold: true
            font.pointSize: 14
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
        }

        ListStorageModel {
            id: dataModel
        }

        ListView {
            anchors.fill: parent
            anchors.topMargin: 45
            clip: true
            spacing: 6
            model: dataModel

            delegate: Rectangle {
                id: oneItem
                width: parent.width
                height: 60
                color: "white"

                Text {
                    id: textEdit
                    anchors.fill: parent
                    anchors.margins: 12
                    text: model.content
                    wrapMode: Text.WordWrap
                    clip: true
                }

                Text {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.margins: 12
                    text: model.createTime
                    color: "#666"
                    wrapMode: Text.NoWrap
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        editItem.uid = model.uid;
                        editItem.content = model.content;
                        editItem.x = 0;
                    }
                }
            }

            footer: Button {
                width: parent.width
                height: 30
                text: "New"

                onClicked: {
                    editItem.uid = -1;
                    editItem.content = "New Content ...";
                    editItem.x = 0;
                }
            }
        }

        Rectangle {
            id: editItem
            x: parent.width
            width: parent.width
            height: parent.height
            clip: true

            property int uid: -1
            property alias content: contentEdit.text

            function hideItem() {
                x = parent.width;
            }

            RowLayout {
                width: parent.width
                height: 30
                spacing: 6
                Button {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "Ok"
                    onClicked: {
                        if (editItem.uid === -1) {
                            dataModel.appendRow({ "content": contentEdit.text });
                        } else {
                            dataModel.setProperty(editItem.uid,"content",contentEdit.text);
                        }
                        editItem.hideItem();
                    }
                }
                Button {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "Cancel"
                    onClicked: editItem.hideItem();
                }
            }

            TextEdit {
                id: contentEdit
                anchors.fill: parent
                anchors.topMargin: 30 + 12
                anchors.bottomMargin: 30 + 12
                wrapMode: TextEdit.WordWrap
                font.pointSize: 14
            }

            Button {
                width: 100
                height: 30
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                text: "Delete"
                onClicked: {
                    console.log(editItem.uid);
                    if (editItem.uid !== -1) {
                        dataModel.removeRow(editItem.uid);
                    }
                    editItem.hideItem();
                }
            }
        }
    }

    AndyQuick.LoginPage {
        anchors.fill: parent
        onLogin: {
            if (account === 'andy' && passwd === 'okandy') {
                visible = false;
                centralItem.visible = true;
            }
        }
    }
}
