import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import App 1.0
import "./qml" as AppQml

ApplicationWindow {
    id: app
    visible: true
    width: 300
    height: 480
    title: qsTr("Hello World")
    color: "#ECECEC"

    Component.onCompleted: {
        appTip.showTip("Welcome!")
    }

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
            wrapMode: Text.WordWrap
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

        // content
        // [visibleTime]
        function showTip(content,visibleTime) {
            if (visibleTime !== undefined) {
                showTimer.interval = visibleTime
            } else {
                showTimer.interval = 2000
            }
            tip.text = content
            const br = Util.textBoundingRect(Qt.rect(0,0,300,300),0x0004,tip.text,tip.font)
            appTip.width = br.width + 20 >= 300 ? 280 : br.width + 20
            appTip.height = br.height + 20
            appTip.visible = true
        }
    }

    ListModel {
        id: contentModel
        ListElement { title: "Today I do nothing."; text: ""; date: "2020-05-24 12:56:01" }
        ListElement { title: "About hope"; text: ""; date: "2020-05-27 22:12:45" }
    }

    Loader {
        id: mainLoader
        anchors.fill: parent
        sourceComponent: loginComponent
        function login(account,passwd) {
            if (account === 'admin' && passwd === 'admin') {
                mainLoader.sourceComponent = mainPageComponent
            } else {
                appTip.showTip("Login error! Haha! You made a big mistake! So how you want do to fix this problem? ",5000)
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

        Item {
            Button {
                id: mainPageHeader
                anchors.top: parent.top
                width: parent.width
                height: 30
                text: "New"

                onClicked: {
                    mainLoader.sourceComponent = editComponent
                }
            }

            ListView {
                id: contentView
                anchors.top: mainPageHeader.bottom
                anchors.bottom: parent.bottom
                width: parent.width
                spacing: 8
                model: contentModel

                delegate: Rectangle {
                    width: parent.width
                    height: 80
                    radius: 4

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 4
                        Text {
                            text: model.title
                            font.bold: true
                        }
                        Text {
                            text: model.text
                        }
                        Text {
                            text: model.date
                        }
                    }
                }
            }
        }
    }

    Component {
        id: editComponent

        Rectangle {
            TextArea {
                id: editor
                width: parent.width
                anchors.top: parent.top
                anchors.bottom: editBtnsRow.top
                wrapMode: TextArea.WordWrap

                background: Rectangle {
                    color: "white"
                }
            }

            Row {
                id: editBtnsRow
                height: editSaveBtn.height
                anchors.bottom: parent.bottom
                width: parent.width
                spacing: 8
                Button {
                    id: editSaveBtn
                    text:"Save"
                    width: parent.width / 2 - 4
                    onClicked: {
                        contentModel.append({"title":"Everything is ok","text": editor.text.trim(), "date": Qt.formatDateTime(new Date(),"yyyy-MM-dd hh:mm:ss")})
                        mainLoader.sourceComponent = mainPageComponent
                    }
                }

                Button {
                    text: "Cancel"
                    width: parent.width / 2 - 4
                    onClicked: mainLoader.sourceComponent = mainPageComponent
                }
            }
        }
    }
}
