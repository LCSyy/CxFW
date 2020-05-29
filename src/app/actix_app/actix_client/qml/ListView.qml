import QtQuick 2.12
import QtQuick.Layouts 1.12

ListView {
    id: contentView
    delegate: itemComponent
    topMargin: 8
    leftMargin: 8
    rightMargin: 8
    signal itemDoubleClicked(int uid, int idx)

    MouseArea {
        anchors.fill: parent
        onDoubleClicked: {
            const itemPos = mapToItem(contentView,mouse.x,mouse.y)
            const viewX = itemPos.x + contentView.contentX
            const viewY = itemPos.y + contentView.contentY
            const item = contentView.itemAt(viewX,viewY)
            const idx = contentView.indexAt(viewX,viewY)
            contentView.itemDoubleClicked(item === null ? 0 : item.uid, idx)
        }
    }

    Component {
        id: itemComponent

        Rectangle {
            width: parent.width - 16
            height: 120
            radius: 4

            property int uid: model.uid

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4
                Text {
                    Layout.fillWidth: true
                    text: model.title
                    elide: Text.ElideRight
                    font.bold: true
                }
                Text {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.topMargin: 16
                    text: model.text
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    elide: Text.ElideRight
                }
                Text {
                    Layout.fillWidth: true
                    text: model.date
                    horizontalAlignment: Qt.AlignRight
                }
            }
        }
    }
}
