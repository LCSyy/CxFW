import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import App.Type 1.0 as AppType

Controls.Popup {
    modal: true
    anchors.centerIn: parent
    padding: 8
    implicitWidth: parent.width * 0.8
    implicitHeight: parent.height * 0.8
    background: Rectangle {
        radius: 4
        border.width: 1
        border.color: AppType.Theme.bgLightColor
    }

    property bool destroyOnHide: true
    property alias header: page.header
    property alias footer: page.footer
    property alias body: page.contentItem

    onVisibleChanged: {
        if (!visible && destroyOnHide) {
            console.log("Destroy on hide!");
            destroy();
        }
    }
    Controls.Page {
        id: page
        anchors.fill: parent
    }
}
