import QtQuick 2.15
import QtQuick.Controls 2.15

import "." as App

Item {
    id: control

    Rectangle {
//            color: "#3e3841" // 剑锋紫
            color: "#35333c" // 沙鱼灰
//            color: "#7cabb1" // 闪蓝
//            color: "#a61b29" // 苋菜红
        //    color: "#495c69" // 战舰灰
        //    color: "#74787a" // 嫩灰
        width: parent.width
        height: parent.height
    }

    App.Button {
        anchors.centerIn: parent
        text: qsTr("Start Journey")
        font.pointSize: 18
        onClicked: control.visible = false
    }
}
