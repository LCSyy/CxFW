import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import Universe 0.1
import "../qml/AppConfigs.js" as AppConfig

Pane {
    background: Rectangle {
        color: "white"
    }

    GridLayout {
        anchors.fill: parent
        columns: 4
        columnSpacing: 8
        rowSpacing: 8

        Text {
            Layout.columnSpan: 4
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: qsTr("Server")
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            font.pointSize: Qt.application.font.pointSize + 4
            font.bold: true
        }

        Text { text: qsTr("Host") }
        TextField {
            Layout.columnSpan: 3
            Layout.fillWidth: true
            Layout.fillHeight: true

            Component.onCompleted: { text = CxSettings.get("host") || "" }
            onTextEdited: { CxSettings.set("host", text.trim()) }
        }

        Text { text: qsTr("Port") }
        TextField {
            Layout.columnSpan: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
            Component.onCompleted: { text = CxSettings.get("port") || "" }
            onTextEdited: { CxSettings.set("port", text.trim()) }
        }

        Text { text: qsTr("Auth key") }
        TextField {
            Layout.columnSpan: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
            Component.onCompleted: { text = CxSettings.get("basicAuthKey") || "" }
            onTextEdited: { CxSettings.set("basicAuthKey", text.trim()) }
        }

        Text { text: qsTr("Auth value") }
        TextField {
            Layout.columnSpan: 3
            Layout.fillWidth: true
            Layout.fillHeight: true
            Component.onCompleted: { text = CxSettings.get("basicAuthValue") || "" }
            onTextEdited: { CxSettings.set("basicAuthValue", text.trim()) }
        }

        Text {
            Layout.columnSpan: 4
            Layout.fillWidth: true
            Layout.fillHeight: true
            text: qsTr("Writer - Content Editor")
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            font.pointSize: Qt.application.font.pointSize + 4
            font.bold: true
        }

        CheckBox {
            Layout.columnSpan: 4
            text: qsTr("Line Wrap")
            onCheckStateChanged: {
                CxSettings.set(AppConfig.settings.contentLineWrap, (checkState === Qt.Checked));
            }
            Component.onCompleted: {
                checkState = CxSettings.get(AppConfig.settings.contentLineWrap) === "true" ? Qt.Checked : Qt.Unchecked;
            }
        }

        Label {
            text: qsTr("Font point size")
        }

        ComboBox {
            model: [9,10,11,12,13,14]
            currentIndex: 0
            onCurrentIndexChanged: {
                 CxSettings.set(AppConfig.settings.contentFontPointSize, parseInt(textAt(currentIndex)))
            }

            Component.onCompleted: {
                const curVal = CxSettings.get(AppConfig.settings.contentFontPointSize) || ""
                for (var i = 0; i < count; ++i) {
                    if (textAt(i) === curVal.toString()) {
                        currentIndex = i;
                        break;
                    }
                }
            }
        }

    }
}
