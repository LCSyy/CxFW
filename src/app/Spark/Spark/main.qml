import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12

import "./qml" as Spark
import Spark 1.0 as Spark

// Spark Theme
// background: {
//   color: "#447999"
//   active_color: "#669BBB"
// }

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    Component.onCompleted: showMaximized()

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("New")
                onTriggered: {
                    newSettingPopup.open()
                }
            }
            MenuItem {
                text: qsTr("Open")
            }
            MenuSeparator {}
            MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }
        Menu { title: qsTr("Edit") }
        Menu { title: qsTr("View") }
        Menu { title: qsTr("Help") }
    }

    Spark.Canvas {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 100
        height: 100
    }

    Dialog {
        id: newSettingPopup
        anchors.centerIn: parent
        dim: true
        closePolicy: Popup.NoAutoClose
        padding: 20
        width: 400
        height: 450
        title: qsTr("New Canvas")

        Column {
            id: formColumn
            x: (parent.width - width)/2
            spacing: 20

            property int firstColWidth: Math.max(fileNameLabel.width,sizeLabel.width)

            Item {
                implicitHeight: Math.max(fileNameLabel.height,fileNameField.height)
                implicitWidth: fileNameLabel.width + fileNameField.width
                Label {
                    id: fileNameLabel
                    anchors.verticalCenter: parent.verticalCenter
                    text: "file name:"
                }
                TextField {
                    id: fileNameField
                    anchors.left: fileNameLabel.right
                    anchors.leftMargin: formColumn.firstColWidth - fileNameLabel.width
                    anchors.verticalCenter: parent.verticalCenter
                    placeholderText: qsTr("Canvas file name")
                }
            }

            Item {
                implicitHeight: Math.max(sizeLabel.height,sizeLabel.height)
                implicitWidth: sizeLabel.width + sizeRow.implicitWidth
                Label {
                    id: sizeLabel
                    anchors.verticalCenter: parent.verticalCenter
                    text: "size:"
                }
                Row {
                    id: sizeRow
                    spacing: 10
                    anchors.leftMargin: formColumn.firstColWidth - sizeLabel.width
                    anchors.left: sizeLabel.right
                    anchors.verticalCenter: parent.verticalCenter
                    TextField {
                        placeholderText: qsTr("width")
                    }

                    TextField {
                        placeholderText: qsTr("height")
                    }
                }
            }
        }

        footer: Row {
            layoutDirection: Qt.RightToLeft
            spacing: 5
            Button {
                text: qsTr("Cancel")
                onClicked: newSettingPopup.reject()
            }
            Button {
                text: qsTr("Ok")
                onClicked: newSettingPopup.accept()
            }
        }
    }

//    Loader {
//        id: pageLoader
//        anchors.fill: parent
//        sourceComponent: startUp
//    }

//    Component {
//        id: startUp
//        Spark.StartUpPage {
//            anchors.fill: parent
//        }
//    }
}
