import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    height: Math.max(row.height, 30)

    property alias text: msgBlock.text
    property alias color: msgBlock.color

    Row {
        id: row
        anchors.right: index % 2 === 0 ? parent.right: undefined
        anchors.left: index % 2 === 0 ? undefined : parent.left
        spacing: 8
        leftPadding: 16
        rightPadding: 16
        Rectangle {
            width: 30
            height: 30
            radius: 15
            color:"white"
            visible: index % 2 !== 0

            Text {
                anchors.fill: parent
                text: "R"
                font.pointSize: Qt.application.font.pointSize + 4
                font.bold: true
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
            }
        }

        TextRect {
            id: msgBlock
        }

        Rectangle {
            width: 30
            height: 30
            radius: 15
            color: "white"
            visible: index % 2 === 0

            Text {
                anchors.fill: parent
                text: "I"
                font.pointSize: Qt.application.font.pointSize + 4
                font.bold: true
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
            }
        }
    }
}
