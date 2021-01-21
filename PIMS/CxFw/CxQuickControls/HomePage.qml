import QtQuick 2.15
import QtQuick.Controls 2.15
import CxQuick 0.1

Item {
    id: control

    signal login(string user, string password)

//    property alias warningText: warning.text
//    property alias userFieldText: userField.text
//    property alias passwordFieldText: passwordField.text

    Rectangle {
        color: ColorSheet.homeBackground
        width: parent.width
        height: parent.height

        Button {
            text: qsTr("Start")
            anchors.centerIn: parent
//            font.pointSize: Qt.application.font.pointSize + 8
            onClicked: control.login('','')
        }

//        Column {
//            anchors.centerIn: parent
//            spacing: 8
//            Column {
//                spacing: 4
//                Text {
//                    text: qsTr("User")
//                    font.pointSize: 12
//                    color: "white"
//                }
//                TextField {
//                    id: userField
//                }
//            }
//            Column {
//                spacing: 4
//                Text {
//                    text: qsTr("Password")
//                    font.pointSize: 12
//                    color: "white"
//                }
//                TextField {
//                    id: passwordField
//                    echoMode: TextInput.Password
//                }
//            }
//            Button {
//                text: qsTr("Start")
//                width: parent.width
//                font.pointSize: 18
//                onClicked: control.login(userField.text.trim(), passwordField.text.trim())
//            }
//            Text {
//                id: warning
//                text: ""
//                color: "#ee3f4d"
//            }
//        }

    }
}
