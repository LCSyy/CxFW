import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Control {
    id: control

    signal sendMsg(string msg)
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    function send() {
        const newMsg = msgBox.text.trim();
        if (newMsg.length > 0) {
            control.sendMsg(newMsg);
        }
        msgBox.clear();
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        color: "white"
    }

    Shortcut {
        sequence: 'Ctrl+Return'
        onActivated: control.send()
    }

    contentItem: ColumnLayout {
        spacing: 0
        ScrollView {
            Layout.fillWidth: true
            Layout.maximumHeight: 100
            Layout.minimumHeight: sendBtn.height
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
            ScrollBar.vertical.policy: ScrollBar.AsNeeded
            TextArea {
                id: msgBox
                selectByMouse: true
                placeholderText: qsTr("Write a message ...")
                wrapMode: TextEdit.WrapAtWordBoundaryOrAnywhere
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "grey"
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 4
            Layout.rightMargin: 4
            Button {
                text: qsTr("Shot")
            }
            Button {
                text: qsTr("File")
            }
            Item {
                Layout.fillWidth: true
            }
            Button {
                id: sendBtn
                Layout.alignment: Qt.AlignRight
                text: qsTr("Send")
                onClicked: control.send()
            }
        }
    }
}
