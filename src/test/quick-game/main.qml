import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Shapes 1.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Shape {
        anchors.centerIn: parent
        width: 200
        height: 200
        ShapePath {
            fillColor: "red"
            startX: 60
            startY: 120
            strokeColor: "red"
            PathArc {
                x: 100; y: 100
                radiusX: 22; radiusY: 22
                useLargeArc: true
            }
            PathArc {
                x: 140; y: 120
                radiusX: 22; radiusY: 22
                useLargeArc: true
            }
            PathLine {
                x: 100; y: 170
            }
        }
    }
}
