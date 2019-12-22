import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Templates 2.12 as T

T.TextField {
    id: control

    implicitHeight: 30
    implicitWidth: 100

    cursorDelegate: Item {
        width: 2
        height: control.implicitHeight
        visible: control.activeFocus
        Rectangle {
            y: 2
            width: 2
            height: parent.height - 4
            color: "#447999"
        }
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 30
        border.color: control.activeFocus ? "#669BBB" : "#447999"
    }
}
