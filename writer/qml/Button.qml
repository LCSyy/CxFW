import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import App.Type 1.0

Controls.Button {
    id: button

    leftInset: 0
    topInset: 0
    rightInset: 0
    bottomInset: 0

    background: Rectangle {
        radius: 2
        color: button.pressed ? Theme.bgNormalColor : Theme.bgLightColor
    }
}
