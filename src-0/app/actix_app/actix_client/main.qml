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

    ListModel {
        id: contentModel
        ListElement { uid: 1; title: "Today I do nothing."; text: ""; date: "2020-05-24 12:56:01" }
        ListElement { uid: 2; title: "About hope"; text: ""; date: "2020-05-27 22:12:45" }
    }

    Loader {
        id: mainLoader
        anchors.fill: parent
        // sourceComponent: loginComponent
        sourceComponent: mainPageComponent
        function login(account,passwd) {
            if (account === 'admin' && passwd === 'admin') {
                mainLoader.sourceComponent = mainPageComponent
            } else {
                appTip.showTip("Login error! Haha! You made a big mistake! So how you want do to fix this problem? ",5000)
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

            AppQml.ListView {
                anchors.top: mainPageHeader.bottom
                anchors.bottom: parent.bottom
                width: parent.width
                spacing: 8
                clip: true
                model: contentModel

                onItemDoubleClicked:{
                    console.log("clicked item uid:",uid,",index:",idx)

                }
            }
        }
    }

    Component {
        id: editComponent

        Rectangle {

            function loadContent(uid) {

            }

            TextField {
                id: titleField
                width: parent.width
                placeholderText: "title"
            }

            TextArea {
                id: editor
                width: parent.width
                anchors.top: titleField.bottom
                anchors.bottom: editBtnsRow.top
                wrapMode: TextArea.WordWrap
                font.pointSize: app.font.pointSize + 2

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
                    width: parent.width / 3 - 2
                    onClicked: {
                        const title = titleField.text.trim()
                        const content = editor.text.trim()
                        if (title !== '' || content !== '') {
                            contentModel.append({
                                                    "title": title,
                                                    "text": content,
                                                    "date": Qt.formatDateTime(new Date(),"yyyy-MM-dd hh:mm:ss")
                                                })
                        }
                        mainLoader.sourceComponent = mainPageComponent
                    }
                }

                Button {
                    text: "Remove"
                    width: parent.width / 3 - 4
                    onClicked: {
                        contentModel.remove()
                    }
                }

                Button {
                    text: "Cancel"
                    width: parent.width / 3 - 2
                    onClicked: mainLoader.sourceComponent = mainPageComponent
                }
            }
        }
    }
}
