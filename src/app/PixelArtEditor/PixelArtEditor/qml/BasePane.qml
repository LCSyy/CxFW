import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Pane {
    padding: 0

    Column {
        anchors.fill: parent
        spacing: 6
        padding: 0

        Rectangle {
            height: 30
            width: parent.width
            border.width: 1
            Row {
                anchors.fill: parent
                Label {
                    height: parent.height
                    verticalAlignment: Qt.AlignVCenter
                    text: "Pane Title"
                    leftPadding: 6
                }
            }
        }

        Rectangle {
            width: parent.width
            height: parent.height - 30
            border.width: 1
        }
    }
}
