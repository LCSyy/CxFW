import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import CxLogin 0.1

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Pass Keeper")

    ColumnLayout {
        anchors.centerIn: parent

        Label {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.bottomMargin: 30
            text: "Pass Keeper"
            font.pixelSize: 40
            font.bold: true
            color: "#009ad6"
        }

        CxLogin {
            onLogin: {
                console.log(account,pass)
            }
        }
    }
}
