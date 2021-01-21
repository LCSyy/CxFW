import QtQuick 2.15
import QtQuick.Controls 2.15
import CxQuick 0.1

Item {
    id: control

    signal login(string user, string password)

    Rectangle {
        color: BoxTheme.backgroundActive
        width: parent.width
        height: parent.height

        Button {
            text: qsTr("Start")
            anchors.centerIn: parent
            font.pointSize: 18
            onClicked: control.login('','')
        }
    }
}
