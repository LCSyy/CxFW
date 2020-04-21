import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "qml" as P

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

    Popup {
        id: new_popup
        anchors.centerIn: parent
        width: 600
        height: 300
        padding: 0

        P.BasePane {
            anchors.fill: parent
        }
    }
}
