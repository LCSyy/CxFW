import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    Column {
        anchors.centerIn: parent
        spacing: 10
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Spark is a game art tool."
            font.pointSize: 14
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Create new..."
        }

    }
}
