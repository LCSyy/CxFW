import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import Andy 1.0
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
    minimumWidth: 320
    maximumWidth: 500
    height: 580
    minimumHeight: 400
    maximumHeight: 800
    title: "Snippet Manager"
    color: "#F1F1F1"

    Item {
        id: centralItem
        anchors.fill: parent
        visible: false

        RowLayout {
            width: parent.width
            height: 45

            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "Snippet Manager"
                font.bold: true
                font.pointSize: 14
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
            }

            Button {
                width: 45
                Layout.fillHeight: true
                text: "Lock"
                onClicked: {
                    loginPage.clearPassword();
                    loginPage.visible = true;
                    centralItem.visible = false;
                }
            }
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
                    anchors.rightMargin: 12
                    text: model.modifyTime
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
                    editItem.content = "";
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
                        dataModel.refresh();
                    }
                }
                Button {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    text: "Cancel"
                    onClicked: {
                        editItem.hideItem();
                        dataModel.refresh();
                    }
                }
            }

            ScrollView {
                  anchors.fill: parent
                  anchors.topMargin: 30 + 12
                  anchors.bottomMargin: 30 + 12

                  TextArea {
                      id: contentEdit
                      wrapMode: TextEdit.WordWrap
                      font.pointSize: 14
                      tabStopDistance: 4
                      placeholderText: "New Content ..."
                      FontMetrics {
                          font: contentEdit.font

                          Component.onCompleted: {
                              contentEdit.tabStopDistance = advanceWidth('A') * 4
                          }
                      }
                  }
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
                    dataModel.refresh();
                }
            }
        }
    }

    AndyQuick.LoginPage {
        id: loginPage
        anchors.fill: parent
        onLogin: {
            if (Backend.signIn(account,passwd)) {
                visible = false;
                centralItem.visible = true;
                dataModel.setPassword(passwd + 'af7fFDAf548dFd87');
                dataModel.refresh();
            }
        }
    }
}
