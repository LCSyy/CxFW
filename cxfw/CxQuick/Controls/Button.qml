import QtQuick 2.15
import QtQuick.Templates 2.15 as T

T.Button {
    id: control

    contentItem: Text {
        text: control.text
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        radius: 4
        color: control.hovered ? control.palette.highlight : control.palette.button
    }
}
