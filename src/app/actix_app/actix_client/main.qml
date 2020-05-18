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
            if (data.method === "app_register") {
                textModel.append({"name":"about","title":"About","text":data.msg})
            }
        }
    }

    ListView {
        anchors.fill: parent
        anchors.topMargin: 16
        anchors.leftMargin: 16
        anchors.rightMargin: 16
        spacing: 16

        model: ListModel {
            id: textModel
            ListElement { name: "one"; title: "One"; text: "This is first paragraph." }
        }

        delegate: Rectangle {
            width: parent.width
            height: 200
            radius: 8
            color: "white"

            Text {
                anchors.fill: parent
                height: 40
                padding: 16
                text: model.text
            }
        }
    }

    footer: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                Layout.fillWidth: true
                Layout.fillHeight: true
                text: "Send"
                onClicked: {
                    httpAccesser.request("Hello, This is message from client!");
                }
            }
        }
    }
}
