import QtQuick 2.15
import QtQuick.Controls 2.15 as C
import QtQuick.Layouts 1.15

C.Popup {

    property bool destroyOnHide: true
    property alias header: page.header
    property alias footer: page.footer
    property alias body: page.contentItem
    property alias tools: toolBarItems.children

    modal: true
    anchors.centerIn: parent
    padding: 2
    topPadding: 4
    bottomPadding: 4
    leftInset: 0
    rightInset:0
    topInset: 0
    bottomInset: 0
    implicitWidth: parent.width * 0.8
    implicitHeight: parent.height * 0.8

    background: Rectangle {
        radius: 4
        color: "#e2e1e4"
    }

    contentItem: C.Page {
        id: page
        header: C.ToolBar {
            RowLayout {
                Item {
                    id: toolBarItems
                }

                Item {
                    Layout.fillWidth: true
                }

                C.ToolButton {}
                C.ToolButton {}
                C.ToolButton {}
            }
        }
    }

    onVisibleChanged: {
        if (!visible && destroyOnHide) {
            destroy();
        }
    }
}
