import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import CxIM 1.0

Item {

    ListView {
        id: listView
        anchors.fill: parent
        spacing: 20
        anchors.margins: 10
        boundsBehavior: Flickable.StopAtBounds
        model: chatMsgModel
        header: Text {
            width: parent.width
            height: 50
            text: qsTr("no more messages")
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
        }
        onCountChanged: {
            const headerHeight = 50;
            const visiableHeight = contentHeight * visibleArea.heightRatio
            contentY = (contentHeight > height) ? (contentHeight + headerHeight - visiableHeight) : (-headerHeight)
        }

        delegate: Item {
            id: chatItem
            width: parent.width
            height: chatInfo.height + chatMsg.height + 10

            Rectangle {
                id: chatUserIcon
                x: model.who === 'L' ? 0: parent.width - width
                width: 30
                height: 30
                radius: 15
                color: model.color
            }

            Text {
                id: chatInfo
                anchors.top: chatUserIcon.top
                anchors.left: model.who === 'L' ? chatUserIcon.right : undefined
                anchors.right: model.who === 'L' ? undefined : chatUserIcon.left
                anchors.leftMargin: model.who === 'L' ? 10 : undefined
                anchors.rightMargin: model.who === 'L' ? undefined : 10
                width: parent.width - chatUserIcon.width - 10
                height: 20
                horizontalAlignment: model.who === 'L' ? Qt.AlignLeft : Qt.AlignRight
                text: model.who === 'L' ? model.name + ' ' + model.dt : model.dt + ' ' +model.name
            }

            Rectangle {
                id: chatMsg
                anchors.top: chatInfo.bottom
                anchors.left: model.who === 'L' ? chatInfo.left : undefined
                anchors.right: model.who === 'L' ? undefined : chatInfo.right
                width: textMetrics.textRect.width + 20
                height: textMetrics.textRect.height + 20
                color: Qt.lighter(model.color,1.3)
                radius: 5
                Text {
                    id: msg
                    anchors.fill: parent
                    anchors.margins: 10
                    text: model.msg
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    color: "white"
                    // textFormat: Text.RichText
                }
                TextMetrics {
                    id: textMetrics
                    property rect textRect: boundingRect(Qt.rect(0,0,chatItem.width - chatUserIcon.width - 10 - 100,100), model.msg)
                }
            }
        }
    }
}
