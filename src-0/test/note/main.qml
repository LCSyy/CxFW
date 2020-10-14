import QtQuick 2.14

ListView {
    spacing: 3
    model: 3
    delegate: Rectangle {
        width: parent.width
        height: 60

        radius: 6
        color: '#568913'
    }
}
