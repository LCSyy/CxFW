import QtQuick 2.15

Rectangle {
    id: msgRect
    color: "#ABCDEF"
    radius: 4
    width: msgText.contentWidth + msgText.leftPadding + msgText.rightPadding
    height: msgText.height

    property alias text: msgText.text

    Text {
        id: msgText
        width: 300
        padding: 8
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }
}
