import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import Qt.labs.settings 1.1 as Q
import CxQuick 0.1 as Cx
import "../Controls" as Cx

Cx.Popup {
    id: popup
    destroyOnHide: false
    implicitWidth: parent.width * 0.95
    implicitHeight: parent.height * 0.95

    property alias contentLineWrap: appSettings.contentLineWrap
    property alias contentFontPointSize: appSettings.contentFontPointSize
    property alias host: appSettings.host
    property alias port: appSettings.port
    property alias basicAuthKey: appSettings.basicAuthKey
    property alias basicAuthValue: appSettings.basicAuthValue

    function basicAuth() {
        var auth = {
            "Authorization": appSettings.basicAuthKey + ":" + appSettings.basicAuthValue,
        };
        return auth;
    }

    Q.Settings {
        id: appSettings
        property bool contentLineWrap: true
        property int contentFontPointSize: app.font.pointSize
        property string host: "localhost"
        property int port: 80
        property string basicAuthKey: ""
        property string basicAuthValue: ""
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Cx.Theme.baseMargin
            anchors.rightMargin: Cx.Theme.baseMargin

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
        GridLayout {
            anchors.fill: parent
            columns: 2
            columnSpacing: Cx.Theme.baseMargin
            rowSpacing: Cx.Theme.baseMargin

            Label {
                Layout.fillWidth: true
                Layout.margins: Cx.Theme.baseMargin
                Layout.columnSpan: 2
                // horizontalAlignment: Qt.AlignHCenter
                text: qsTr("Content Editor")
                font.pointSize: app.font.pointSize + 4
                font.bold: true
            }

            CheckBox {
                Layout.columnSpan: 2
                Layout.margins: Cx.Theme.baseMargin
                text: qsTr("Line Wrap")
                onCheckStateChanged: {
                    appSettings.contentLineWrap = (checkState === Qt.Checked);
                }
                Component.onCompleted: {
                    checkState = appSettings.contentLineWrap === true ? Qt.Checked : Qt.Unchecked;
                }
            }

            Label {
                text: qsTr("Font Point Size")
                Layout.margins: Cx.Theme.baseMargin
            }

            ComboBox {
                model: [9,10,11,12,13,14]
                currentIndex: 0
                onCurrentIndexChanged: {
                     appSettings.contentFontPointSize = parseInt(textAt(currentIndex))
                }

                Component.onCompleted: {
                    const curVal = appSettings.contentFontPointSize
                    for (var i = 0; i < count; ++i) {
                        if (textAt(i) === curVal.toString()) {
                            currentIndex = i;
                            break;
                        }
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                Layout.margins: Cx.Theme.baseMargin
                Layout.columnSpan: 2
                // horizontalAlignment: Qt.AlignHCenter
                text: qsTr("Server")
                font.pointSize: app.font.pointSize + 4
                font.bold: true
            }

            Label {
                text: qsTr("Host")
                Layout.margins: Cx.Theme.baseMargin
            }

            TextField {
                onEditingFinished: {
                    appSettings.host = text.trim();
                }
                Component.onCompleted: {
                    text = appSettings.host;
                }
            }

            Label {
                text: qsTr("Port")
                Layout.margins: Cx.Theme.baseMargin
            }

            TextField {
                onEditingFinished: {
                    appSettings.port = parseInt(text.trim());
                }
                Component.onCompleted: {
                    text = appSettings.port;
                }
            }

            Label {
                text: qsTr("Auth key")
                Layout.margins: Cx.Theme.baseMargin
            }

            TextField {
                onEditingFinished: {
                    appSettings.basicAuthKey = text.trim();
                }
                Component.onCompleted: {
                    text = appSettings.basicAuthKey;
                }
            }

            Label {
                text: qsTr("Auth value")
                Layout.margins: Cx.Theme.baseMargin
            }

            TextField {
                onEditingFinished: {
                    appSettings.basicAuthValue = text.trim();
                }
                Component.onCompleted: {
                    text = appSettings.basicAuthValue;
                }
            }

            Item {
                Layout.fillHeight: true
                Layout.columnSpan: 2
            }
        }
    }
}
