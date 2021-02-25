import QtQuick 2.15
import QtQuick.Controls 2.15 as C

C.Popup {

    property bool destroyOnHide: true
    property alias header: page.header
    property alias footer: page.footer
    property alias body: page.contentItem

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
    }

    onVisibleChanged: {
        if (!visible && destroyOnHide) {
            destroy();
        }
    }
}
