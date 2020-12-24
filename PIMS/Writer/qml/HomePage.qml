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

    Rectangle {
        color: "#74787a"
        width: parent.width
        height: parent.height

        Button {
            anchors.centerIn: parent
            text: qsTr("Start Journey")
            font.pointSize: 18
            onClicked: control.visible = false
        }
    }

//    Rectangle {
//        color: "#35333c"
//        x: parent.width / 2
//        width: parent.width / 2
//        height: parent.height

//        Button {
//            anchors.centerIn: parent
//            text: qsTr("Start Journey")
//            font.pointSize: 18
//        }
//    }
}
