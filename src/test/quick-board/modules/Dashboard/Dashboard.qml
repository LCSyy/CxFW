import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Shapes 1.12
import QuickBoard 1.0

Page {
    anchors.fill: parent
    property string moduleName: ""
    Shape {
        id: _shape
        width: 300
        height: 150 * Math.sqrt(3)
        anchors.centerIn: parent
        ShapePath {
            fillColor: "#DC143C"
            startX: 0; startY: _shape.height
            PathLine { x:_shape.width/3; y: _shape.height }
            PathLine { x:_shape.width/2; y: _shape.height*2/3 }
            PathLine { x:_shape.width*2/3; y: _shape.height }
            PathLine { x: _shape.width; y: _shape.height }
            PathLine { x: _shape.width/2; y: 0 }
        }
    }
    Text {
        id: _studioName
        text: "Arrow Studio"
        font.pointSize: 48
        anchors.horizontalCenter: _shape.horizontalCenter
        anchors.top: _shape.bottom
        anchors.topMargin: -15
    }
}
