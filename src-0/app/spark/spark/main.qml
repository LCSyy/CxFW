import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

// 2048
// Dots and Boxes
// Sprouts
// Sudokus

import "2048" as Game2048

ApplicationWindow {
    id: app
    visible: true
    width: 640
    height: 480
    title: qsTr("Spark")

    Component.onCompleted: showMaximized()

    header: ToolBar {
        ComboBox {
            model: ["2048","sprouts"]
            onCurrentTextChanged: {
                if (currentText === "2048") {
                    gameLoader.source = "qrc:/2048/Game.qml";
                } else if (currentText === "sprouts") {
                    gameLoader.source = "qrc:/Sprouts/Game.qml";
                }
            }
        }
    }

    Loader {
        id: gameLoader
        anchors.fill: parent
    }
}
