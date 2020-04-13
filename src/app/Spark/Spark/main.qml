import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

// 2048
// Dots and Boxes

Window {
    id: app
    visible: true
    width: 640
    height: 480
    title: qsTr("Spark")

    QtObject {
        id: config

        property int canvasSize: app.width <= app.height ? app.width : app.height
        property color canvasColor: "#B7AAA1"
        property int blockSize: canvasSize / 4
    }

    Item {
        anchors.centerIn: parent
        width: config.canvasSize
        height: config.canvasSize

        Rectangle {
            anchors.fill: parent
            color: config.canvasColor

            Repeater {
                model: 16
                delegate: Rectangle {
                    x: 0
                    y: 0
                    width: config.blockSize
                    height: config.blockSize
                    color: model.color
                }
            }
        }
    }
}
