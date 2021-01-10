import QtQuick 2.15
import QtQuick.Controls 2.15

// color: "#3e3841" // 剑锋紫
// color: "#35333c" // 沙鱼灰
// color: "#7cabb1" // 闪蓝
// color: "#a61b29" // 苋菜红
// color: "#495c69" // 战舰灰
// color: "#74787a" // 嫩灰

Item {
    id: control

    signal login(string user, string password)

//    property alias warningText: warning.text
//    property alias userFieldText: userField.text
//    property alias passwordFieldText: passwordField.text

    Rectangle {
        color: "#74787a"
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
