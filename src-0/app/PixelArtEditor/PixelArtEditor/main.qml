import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

import PixelArt 1.0
import "qml" as P

ApplicationWindow {
    id: app
    visible: true
    width: 640
    height: 480
    title: setWindowTitle("")
    color: "grey"

    // 设置窗口标题
    // title: string 文件标题
    // modified: bool 文件是否发生修改
    function setWindowTitle(title,modified) {
        app.title = qsTr("{0}{1}{2}Pixel Art Editor")
                    .replace("{0}",title)
                    .replace("{1}",modified === true ? "*" : "")
                    .replace("{2}",(title || "") === "" ? "" : " - ");
    }

    // 解析"{num1}x{num2}"格式的字符串
    // sizeStr: string
    // {return}: point
    function str2size(sizeStr) {
        const sizeSections = sizeStr.split("x");
        if (sizeSections.length === 2) {
            return Qt.size(parseInt(sizeSections[0]),parseInt(sizeSections[1]));
        }
        return Qt.size(0,0);
    }

    header: MenuBar {
        Menu {
            title: qsTr("File")
            Action {
                text: "New"
                onTriggered: {
                    new_popup.open()
                }
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

    RectangularGlow {
        id: effect
        color: "white"
        glowRadius: 1
        spread: 0.3
        scale: canvas.scale
        anchors.fill: canvas
    }

    Rectangle {
        id: canvas
        anchors.centerIn: parent
        width: 64
        height: 64
        scale: 6
        color: "grey"
    }

    CanvasLine {
        width: 64
        height: 64
        scale: 6
    }


    // 【新建】弹框界面
    Popup {
        id: new_popup
        anchors.centerIn: parent
        width: 600
        height: 300
        padding: 6

        P.NewFilePane {
            anchors.fill: parent
            title: "New Canvas"
            onClose: {
                const data = getData();
                app.setWindowTitle(data.fileName,true);
                const canvasSize = app.str2size(data.canvasSize);
                canvas.width = canvasSize.width;
                canvas.height = canvasSize.height;
                new_popup.close()
            }
        }
    }
}
