import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

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
    title: qsTr("Hello World")
    color: "#F1F1F1"

    QtObject {
        id: appStatus
        property bool inEdit: false
    }

    Text {
        width: parent.width
        height: 45
        text: "Snippet Manager"
        font.bold: true
        font.pointSize: 14
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
    }

    ListModel {
        id: dataModel
        ListElement { text: "Welcome to [Snippet Manager]" }
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
                text: model.text
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    editItem.index = model.index;
                    editItem.content = model.text;
                    editItem.x = 0;
                }
            }
        }

        footer: Button {
            width: parent.width
            height: 30
            text: "New"

            onClicked: {
                editItem.index = -1;
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

        property int index: -1
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
                    if (editItem.index === -1) {
                        dataModel.append({ "text": contentEdit.text });
                    } else {
                        dataModel.setProperty(editItem.index,"text",contentEdit.text);
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
        }

        Button {
            width: 100
            height: 30
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            text: "Delete"
            onClicked: {
                if (editItem.index !== -1) {
                    dataModel.remove(editItem.index);
                }
                editItem.hideItem();
            }
        }
    }

}
