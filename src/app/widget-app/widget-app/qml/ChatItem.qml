import QtQuick 2.12

Item {
    id: chatItem
    // width: parent.width
    height: msgBg.height + 20

    property alias message: msgText.text

    // true: me, false: others
    property bool who
    property rect textRect

    Rectangle {
        id: userIcon
        x: chatItem.who === true ? chatItem.width - 40 : 10
        y: 10
        width: 30
        height: 30
        radius: 15
        color: chatItem.who === true ? "#185346" : "#91AB56"
    }

    Rectangle {
        id: msgBg
        y: 10
        radius: 6
        color: "#789ABC"
        anchors.left: chatItem.who === true ? undefined : userIcon.right
        anchors.right: chatItem.who === true ? userIcon.left : undefined
        anchors.leftMargin: chatItem.who === true ? undefined : 10
        anchors.rightMargin: chatItem.who === true ? 10 : undefined
        width: chatItem.textRect.width + 20
        height: chatItem.textRect.height + 20
        TextEdit {
            id: msgText
            anchors.fill: parent
            padding: 10
            readOnly: true
            selectByMouse: true
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            horizontalAlignment: Qt.AlignLeft
        }
    }
}
