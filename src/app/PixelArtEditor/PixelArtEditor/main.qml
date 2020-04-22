import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12
import "qml" as P

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    color: "grey"

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
            onClose: new_popup.close()
        }
    }
}
