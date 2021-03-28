import QtQuick 2.15
import QtQuick.Controls 2.15
import "../qml/BoxTheme.js" as BoxTheme

Item {
    property alias text: msg.text
    property alias fontSize: msg.font.pointSize
    property alias textWidth: msg.width

    width: msg.contentWidth + msg.leftPadding + msg.rightPadding
    height: msg.contentHeight + msg.topPadding + msg.bottomPadding

    Rectangle {
        anchors.fill: parent
        color: BoxTheme.color8
        radius: 4
    }

    TextEdit {
        id: msg
        wrapMode: Text.WrapAnywhere
        padding: BoxTheme.padding
        selectByMouse: true
        readOnly: true
        selectionColor: "#2376b7"
        textFormat: TextEdit.PlainText
        text: model.msg
    }
}
