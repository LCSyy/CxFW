import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Pane {
    id: pane
    padding: 1
    topPadding: 30 + 7

    signal close()

    property alias title: pane_title.text

    background: Column {
        anchors.fill: parent
        spacing: 6
        padding: 0

        Rectangle {
            height: 30
            width: parent.width
            border.width: 1
            Row {
                anchors.fill: parent
                padding: 1
                Label {
                    id: pane_title
                    height: parent.height - 2
                    width: parent.width - 30
                    verticalAlignment: Qt.AlignVCenter
                    text: "Pane Title"
                    leftPadding: 6
                }

                Rectangle {
                    width:30 - 2
                    height: 30 - 2
                    color: close_area.pressed ? "#ACACAC" : "white"
                    Text {
                        anchors.fill: parent
                        text: "X"
                        horizontalAlignment: Qt.AlignHCenter
                        verticalAlignment: Qt.AlignVCenter
                    }
                    MouseArea {
                        id: close_area
                        anchors.fill: parent
                        onClicked: pane.close()
                    }
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height - 30 - 6
            border.width: 1
        }
    }
}
