import QtQuick 2.15
import QtQuick.Controls 2.15
import CxQuick 0.1
import "../qml" as Universe

Item {
    Button {
        anchors.centerIn: parent
        icon.source: "qrc:/icons/redo-alt.svg"
        icon.height: 25
        icon.width: 25
        display: AbstractButton.IconOnly
        onClicked: popup.open()
    }

    Universe.Popup {
        id: popup
        destroyOnHide: false
        width: Math.min(parent.width * 0.8, 600)
        height: parent.height * 0.9
    }
}
