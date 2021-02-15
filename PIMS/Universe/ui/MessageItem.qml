import QtQuick 2.15
import QtQuick.Controls 2.15
import CxQuick 0.1

Item {
    property alias text: msg.text
    property alias fontSize: msg.font.pointSize
    property alias textWidth: msg.width

    width: msg.contentWidth + msg.leftPadding + msg.rightPadding
    height: msg.contentHeight + msg.topPadding + msg.bottomPadding

    Rectangle {
        anchors.fill: parent
        color: "white"
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
