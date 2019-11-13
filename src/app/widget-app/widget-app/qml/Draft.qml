import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    ListView {
        id: listView
        width: 30
        height: parent.height
        anchors.right: parent.right
        model: ['A','B','C']
        delegate: ToolButton {
            text: modelData
        }
    }
}
