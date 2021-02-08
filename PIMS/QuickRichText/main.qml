import QtQuick 2.15
import QtQuick.Window 2.15
import CxQuick 0.1

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    SyntaxHighlighter {
        document: chatBlock.textDocument
    }

    TextEdit {
        id: chatBlock
        anchors.fill: parent
        textFormat: TextEdit.RichText
        wrapMode: TextEdit.WrapAnywhere
    }
}
