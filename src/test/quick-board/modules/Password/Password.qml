import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Shapes 1.12

Rectangle {
    anchors.fill: parent
    property string moduleName: ""

    Button {
        text: "Save Image"
        onClicked: {
            _logoPure.grabToImage(function(result){ result.saveToFile("ArrowOnly.png"); });
        }
    }

    FontMetrics {
        id: _metrics
        font.pointSize: 48
    }

    Item {
        id: _logoPure
        anchors.centerIn: parent
        width: 320
        height: 320
        Shape {
            id: _shapePure
            width: 320
            height: 160 * Math.sqrt(3)
            anchors.centerIn: parent
            ShapePath {
                strokeColor: "#DC143C"
                strokeWidth: 0.172
                fillColor: "#DC143C"
                startX: 0; startY: _shapePure.height
                PathLine { x:_shapePure.width/3; y: _shapePure.height }
                PathLine { x:_shapePure.width/2; y: _shapePure.height*2/3 }
                PathLine { x:_shapePure.width*2/3; y: _shapePure.height }
                PathLine { x: _shapePure.width; y: _shapePure.height }
                PathLine { x: _shapePure.width/2; y: 0 }
            }
        }
    }

    Item {
        id: _logo
        visible: false
        anchors.centerIn: parent
        width: _metrics.boundingRect("Arrow Studio").width
        height: _shape.height + _studioName.height

        Shape {
            id: _shape
            width: 320
            height: 160 * Math.sqrt(3)
            anchors.horizontalCenter: parent.horizontalCenter
            ShapePath {
                strokeColor: "#DC143C"
                strokeWidth: 0.172
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

}
