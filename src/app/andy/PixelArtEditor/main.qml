import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import CxQuick 1.0 as Cx

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    header: MenuBar {
        Menu {
            title: qsTr("File")

            Action {
                text: "New"
            }

            Action {
                text: "Open"
            }

            Action {
                text: "Save"
            }

            Action {
                text: "Save As"
            }

            Action {
                text: "Export Sprite"
            }

        }
    }

    Rectangle {
        anchors.centerIn: parent
        width: 64
        height: 64
        color: "#CDCDCD"
        scale: 10
        Cx.Canvas {
            id: canvas
            anchors.fill: parent
            shapeType: "line"
            penColor: "black"
        }

        MouseArea {
            anchors.fill: parent

            onPressed: {
                canvas.startPaint(Qt.point(mouse.x,mouse.y))
            }
            onReleased: {
                canvas.stopPaint();
            }
            onPositionChanged: {
                canvas.draw(Qt.point(mouse.x,mouse.y))
            }
        }
    }
}
