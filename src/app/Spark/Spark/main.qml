import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

// 2048
// Dots and Boxes
// Sprouts
// Sudokus

import "2048" as Game2048

Window {
    id: app
    visible: true
    width: 640
    height: 480
    title: qsTr("Spark")

    Game2048.Game {
        anchors.fill: parent
    }
}
