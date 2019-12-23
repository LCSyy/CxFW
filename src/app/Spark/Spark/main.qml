import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12

import "./qml" as SparkQuick
import "./qml/spark" as Spark
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

    Spark.Canvas {
        id: canvas
        anchors.centerIn: parent
        width: 100
        height: 100
        scale: 10
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

            onWheel: {}
        }
    }

    Page {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20

        header: Text {
            text: qsTr("Drawing Panel")
        }

        contentItem: SparkQuick.FormLayout {
                width: parent.width
                height: parent.height - header.height
                SparkQuick.FormItem {
                    text: qsTr("Draw Type")
                    ComboBox {
                        model: ["point","line","rect","triangle","circle","ellipse"]
                    }
                }
            }

        background: Rectangle {
            implicitWidth: 300
            implicitHeight: 400
            color: "grey"
        }
    }

    Dialog {
        id: newSettingPopup
        anchors.centerIn: parent
        dim: true
        closePolicy: Popup.NoAutoClose
        margins: 20
        width: 400
        height: 450
        title: qsTr("New Canvas")

        SparkQuick.FormLayout {
            anchors.fill: parent
            SparkQuick.FormItem {
                text: qsTr("File Name")
                TextField {}
            }

            SparkQuick.FormItem {
                text: qsTr("Canvas Width")
                TextField {}
            }

            SparkQuick.FormItem {
                text: qsTr("Canvas Height")
                TextField {}
            }
        }

        footer: Row {
            layoutDirection: Qt.RightToLeft
            spacing: 5
            padding: 10
            Button {
                text: qsTr("Cancel")
                onClicked: newSettingPopup.reject()
            }
            Button {
                text: qsTr("Ok")
                onClicked: newSettingPopup.accept()
            }
        }
    }
}
