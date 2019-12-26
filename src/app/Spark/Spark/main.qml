import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.13
import QtQuick.Layouts 1.13

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
    width: 800
    height: 600
    title: qsTr("Hello World")

    QtObject {
        id: canvasMode
        property alias shapeType: canvas.shapeType
        property alias penColor: canvas.penColor
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

        Column {
            SplitView.fillHeight: true
            SplitView.preferredWidth: 200
            clip: true

            Rectangle {
                width: parent.width
                height: 100
                color: "#134679"

                GridView {
                    id: mostUsedColorView
                    width: Math.min(parent.width,200)
                    height: parent.height
                    cellWidth: 30
                    cellHeight: 30
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: ["#AC23DC","#CD2389","#0223DC","#23CDDC","#AC23DC","#CC2ADC"]
                    delegate: Rectangle {
                        color: modelData
                        width: 30
                        height: 30
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            const vx = mouse.x + mostUsedColorView.contentX;
                            const vy = mouse.y + mostUsedColorView.contentY;
                            const idx = mostUsedColorView.indexAt(vx,vy);
                            if(idx !== -1) {
                                mostUsedColorView.currentIndex = idx;
                                canvasMode.penColor = mostUsedColorView.currentItem.color;
                            }
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 300
                color: "#521030"

                GridView {
                    id: toolView
                    width: Math.min(parent.width,200)
                    height: parent.height
                    cellWidth: 30
                    cellHeight: 30
                    clip: true
                    boundsBehavior: Flickable.StopAtBounds
                    model: ListModel{
                        id: toolModel
                        ListElement {bg:"#CD2389";tool:"line"}
                        ListElement {bg:"#0223DC";tool:"rect"}
                        ListElement {bg:"#AC23DC";tool:"ellipse"}
                    }
                    delegate: Rectangle {
                        color: bg
                        width: 30
                        height: 30
                        Text {
                            text: tool
                            anchors.fill: parent
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            const vx = mouse.x + toolView.contentX;
                            const vy = mouse.y + toolView.contentY;
                            const idx = toolView.indexAt(vx,vy);
                            if(idx !== -1) {
                                toolView.currentIndex = idx;
                                canvasMode.shapeType = toolModel.get(idx).tool;
                            }
                        }
                    }
                }
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

                    penColor: canvasMode.penColor
                    shapeType: "line"

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

            Text {
                anchors.centerIn: parent
                text: "Canvas"
                font.pointSize: 24
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
