import QtQuick 2.12
import QtQuick.Controls 2.12

BasePane {
    id: newFilePane
    Grid {
        anchors.centerIn: parent
        padding: 6
        spacing: 6
        columns: 2
        verticalItemAlignment: Grid.AlignVCenter

        Text {
            text: "File name"
            verticalAlignment: Qt.AlignVCenter
        }

        TextField {
            width: 200
            height: 30
            placeholderText: "Untitled.png"
        }

        Text {
            text: "Size"
            verticalAlignment: Qt.AlignVCenter
        }

        TextField {
            width: 200
            height: 30
            text: "64x64"
        }
    }

    Button {
        id: sureBtn
        text: "Ok"
        width: 100
        height: 30
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 6
        onClicked: newFilePane.close()
    }
}
