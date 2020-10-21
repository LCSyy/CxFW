import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    QtObject {
        id: theme
        readonly property int innerSpacing: 4
    }

    Grid {
        anchors.centerIn: parent
        columns: 2
        columnSpacing: theme.innerSpacing
        rowSpacing: theme.innerSpacing * 2
        verticalItemAlignment: Qt.AlignVCenter
        horizontalItemAlignment: Qt.AlignRight

        Label {
            text: qsTr("User name")
        }

        TextField {
            placeholderText: qsTr("User name/Phone/Email")
        }

        Label {
            text: qsTr("Password")
        }

        TextField {
            placeholderText: qsTr("Password")
        }
    }

}
