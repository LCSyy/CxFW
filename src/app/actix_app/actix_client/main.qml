import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import App 1.0
import "./qml" as AppQml

ApplicationWindow {
    id: app
    visible: true
    width: 360
    height: 640
    title: qsTr("Hello World")
    color: "#ECECEC"

    Component.onCompleted: appTip.showTip("Welcome!")

    HttpAccessManager {
        id: httpAccesser
        onDataLoaded: {
            console.log(JSON.stringify(data))
            if (data.brief !== "error") {
                textModel.append(data)
            }
        }
    }

    // App Info Banner
    Rectangle {
        id: appTip
        x: (app.width - width) / 2
        y: 30
        width: 100
        height: 30
        color: "white"
        radius: 3
        visible: false

        Text {
            id: tip
            anchors.fill: parent
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
        }

        Timer {
            id: showTimer
            interval: 2000
            repeat: false
            running: appTip.visible
            triggeredOnStart: false
            onTriggered: {
                appTip.visible = false
                tip.text = ""
            }
        }

        function showTip(content) {
            tip.text = content
            appTip.width = Util.textBoundingRect(Qt.rect(0,0,300,300),0x0004,tip.text,tip.font).width + 20
            appTip.visible = true
        }
    }

    Loader {
        id: mainLoader
        anchors.fill: parent
        sourceComponent: loginComponent

        function login(account,passwd) {
            if (account === 'admin' && passwd === 'admin') {
                mainLoader.sourceComponent = mainPageComponent
            } else {
                appTip.showTip("Login error!")
            }
        }
    }

    Component {
        id: loginComponent

        AppQml.LoginPage {
            onClickLogin: mainLoader.login(account,passwd)
        }
    }

    Component {
        id: mainPageComponent

        Rectangle {
            color: "#894313"
        }
    }
}
