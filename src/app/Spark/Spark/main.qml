import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13

import "./qml" as SparkQuick
import "./qml/spark" as SparkItem
import Spark 1.0 as Spark

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
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    Component.onCompleted: showMaximized()

    QtObject {
        id: canvasMode
        property string mode: "line" // point, line, rect, ...
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("New")
                onTriggered: {
                    newSettingPopup.open()
                }
            }
            MenuItem {
                text: qsTr("Open")
            }
            MenuSeparator {}
            MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }
        Menu {
            title: qsTr("Edit")
            MenuItem {
                text: qsTr("Save Canvas")
                onTriggered: {
                    canvas.grabToImage(function(result){
                        var date = new Date();
                        const fileName = date.toLocaleString(Qt.locale(),"yyyyMMddHHmmss") + ".png";
                        if(result.saveToFile(fileName)) {
                            console.log("--- save png ---",fileName);
                        }
                    });
                }
            }
        }
        Menu { title: qsTr("View") }
        Menu { title: qsTr("Help") }
    }

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Rectangle {
            SplitView.fillHeight: true
            SplitView.preferredWidth: 200
            color: "#134679"
            clip: true

            Text {
                anchors.centerIn: parent
                text: "Tools"
                font.pointSize: 24
            }
        }

        Rectangle {
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            color: "#125613"
            clip: true

            Rectangle {
                anchors.centerIn: parent
                width: 64
                height: 64
                scale: 10
                color: "#235689"

                Spark.Canvas {
                    id: canvas
                    anchors.fill: parent
                    smooth: false

                    penColor: Qt.rgba(0.5,0.6,0.35,1)

                    property point startPoint: Qt.point(-1,-1)

                    MouseArea {
                        anchors.fill: parent

                        onPressed: {
                            canvas.startPaint();
                            canvas.startPoint = Qt.point(mouse.x,mouse.y)
                        }

                        onPositionChanged: {
                            if(canvasMode.mode === "line") {
                                canvas.drawLine(canvas.startPoint,Qt.point(mouse.x,mouse.y));
                            }
                        }

                        onReleased: {
                            canvas.stopPaint();
                        }
                    }
                }
            }

            Text {
                anchors.centerIn: parent
                text: "Canvas"
            }
        }

        Rectangle {
            SplitView.fillHeight: true
            SplitView.preferredWidth: 200
            color: "#134679"
            clip: true

            Text {
                anchors.centerIn: parent
                text: "Properties"
                font.pointSize: 24
            }
        }
    }

    SparkItem.NewCanvasDialog {
        id: newSettingPopup
    }
}
