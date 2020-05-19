import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import App 1.0

ApplicationWindow {
    id: app
    visible: true
    width: 360
    height: 640
    title: qsTr("Hello World")
    color: "#ECECEC"

    HttpAccessManager {
        id: httpAccesser
        onDataLoaded: {
            console.log(JSON.stringify(data))
            if (data.brief !== "error") {
                textModel.append(data)
            }
        }
    }

    Loader {
        id: mainLoader
        anchors.fill: parent
        sourceComponent: loginComponent
    }

    Component {
        id: loginComponent

        Item {
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 12
                Grid {
                    columns: 2
                    spacing: 6
                    verticalItemAlignment: Qt.AlignVCenter
                    horizontalItemAlignment: Qt.AlignLeft
                    Text {
                        id: accountLabel
                        text: "Account"
                    }

                    TextField { }

                    Text {
                        id: passwdLabel
                        text: "Password"
                    }

                    TextField { }
                }

                Button {
                    height: 30
                    Layout.fillWidth: true
                    text: "login"
                }
            }
        }

    }
}
