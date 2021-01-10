import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls

Controls.Popup {
    modal: true
    anchors.centerIn: parent
    padding: 0
    implicitWidth: parent.width * 0.8
    implicitHeight: parent.height * 0.8
    background: Rectangle {
        radius: 4
        border.width: 1
    }

    property bool destroyOnHide: true
    property alias header: page.header
    property alias footer: page.footer
    property alias body: page.contentItem

    onVisibleChanged: {
        if (!visible && destroyOnHide) {
            destroy();
        }
    }

    Controls.Page {
        id: page
        anchors.fill: parent
        clip: true
        background: Rectangle {
            radius: 4
            border.width: 1
            border.color: "#e2e1e4"
            color: "#e2e1e4"
        }
    }
}
