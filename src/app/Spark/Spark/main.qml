import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

import "./qml" as SparkQuick
import "./qml/spark" as SparkItem
import CxQuick 1.0 as CxQuick

/*!
Spark Theme:
  background:
    color: "#447999"
    active_color: "#669BBB"
  margins: 10
  spacing:
    relate item: 5
    sibling item: 10
*/

ApplicationWindow {
    id: app
    visible: true
    width: 300
    height: 650
    title: qsTr("Hello World")

    QtObject {
        id: canvasMode
        property alias shapeType: canvas.shapeType
        property alias penColor: canvas.penColor
    }

/*
                    canvas.grabToImage(function(result){
                        var date = new Date();
                        const fileName = date.toLocaleString(Qt.locale(),"yyyyMMddHHmmss") + ".png";
                        if(result.saveToFile(fileName)) {
                            console.log("--- save png ---",fileName);
                        }
                    });
*/

    Rectangle {
        width: Math.floor(app.width / scale)
        height: Math.floor(app.height / scale)
        scale: 5
        anchors.centerIn: parent
        color: "grey"

        CxQuick.Canvas {
            id: canvas
            anchors.fill: parent
            smooth: false

            penColor: canvasMode.penColor
            shapeType: "polyline"

            MouseArea {
                anchors.fill: parent

                onPressed: {
                    canvas.startPaint(Qt.point(mouse.x,mouse.y));
                }

                onPositionChanged: {
                    canvas.draw(Qt.point(mouse.x,mouse.y));
                }

                onReleased: {
                    canvas.stopPaint();
                }
            }
        }
    }

}
