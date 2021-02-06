import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import CxQuick 0.1
import CxQuick.Controls 0.1 as Cx
import "./Config.js" as Config

Cx.Popup {
    id: popup
    implicitWidth: {
        var dw = parent.width * 0.8;
        if (dw > 640) { dw = 640; }
        return dw;
    }
    implicitHeight: parent.height * 0.8

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: CxTheme.baseMargin
            anchors.rightMargin: CxTheme.baseMargin

            Button {
                text: qsTr("Save")
                onClicked: {}
            }

            Item {
                Layout.fillWidth: true
            }

            Button {
                text: qsTr("Cancel")
                onClicked: popup.close()
            }
        }
    }

    body: Item {
        implicitWidth: 100
        implicitHeight: 100
        GridLayout {
            anchors.fill: parent
            columns: 2
            columnSpacing: CxTheme.baseMargin
            rowSpacing: CxTheme.baseMargin

            Label {
                Layout.fillWidth: true
                Layout.margins: CxTheme.baseMargin
                Layout.columnSpan: 2
                // horizontalAlignment: Qt.AlignHCenter
                text: qsTr("Server")
                font.pointSize: app.font.pointSize + 4
                font.bold: true
            }

            Label {
                text: qsTr("Host")
                Layout.margins: CxTheme.baseMargin
            }

            TextField {
                onEditingFinished: {
                    CxSettings.set(Config.settings.host,text.trim());
                }
                Component.onCompleted: {
                    text = CxSettings.get(Config.settings.host);
                }
            }

            Label {
                text: qsTr("Port")
                Layout.margins: CxTheme.baseMargin
            }

            TextField {
                onEditingFinished: {
                    CxSettings.set(Config.settings.port, parseInt(text.trim()));
                }
                Component.onCompleted: {
                    text = CxSettings.get(Config.settings.port);
                }
            }

            Label {
                text: qsTr("Auth key")
                Layout.margins: CxTheme.baseMargin
            }

            TextField {
                onEditingFinished: {
                    CxSettings.set(Config.settings.basicAuthKey, text.trim());
                }
                Component.onCompleted: {
                    text = CxSettings.get(Config.settings.basicAuthKey);
                }
            }

            Label {
                text: qsTr("Auth value")
                Layout.margins: CxTheme.baseMargin
            }

            TextField {
                onEditingFinished: {
                    CxSettings.set(Config.settings.basicAuthValue, text.trim());
                }
                Component.onCompleted: {
                    text = CxSettings.get(Config.settings.basicAuthValue);
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.columnSpan: 2
            }
        }
    }
}
