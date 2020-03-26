import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Window {
    visible: true
    x: (Screen.desktopAvailableWidth - width) / 2
    y: (Screen.desktopAvailableHeight - height) / 2
    width: 640
    height: 480
    title: qsTr("Hello World")


    ListView {
        anchors.fill: parent
        anchors.leftMargin: 12
        anchors.rightMargin: 12
        spacing: 12
        model: ListModel {
            ListElement { title: "New Plan"; text: "This is plan detail."}
            ListElement { title: "Second Plan"; text: "It has different content."}
        }
        delegate: viewItem
    }

    Component {
        id: viewItem

        Rectangle {
            width: parent.width
            height: 100
            color: "#E5E5E5"
            radius: 6

            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                Text {
                    text: model.title
                    font.pointSize: Qt.application.font.pointSize + 3
                    font.bold: true
                }

                Text {
                    text: model.text
                }
            }
        }
    }

}
