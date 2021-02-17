import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import Universe 0.1
import "./ui" as Ui

ApplicationWindow {
    id: window
    title: qsTr("Universe")
    width: 900
    height: 640
    visible: true

    function showWindow() {
        showNormal()
        raise()
        requestActivate()
    }

    function loadPage(name) {
        loginPageConnection.target = null;
        if ("login" === name || Sys.getData("login") !== true) {
            pages.source = "qrc:/ui/LoginPage.qml"
            loginPageConnection.target = pages.item
        } else {
            if ("home" === name) {
                pages.source = "qrc:/ui/HomePage.qml"
                homePageConnection.target = pages.item
            } else if ("writer" === name) {
                pages.source = "qrc:/ui/WriterPage.qml"
            } else if ("frags" === name) {
                pages.source = "qrc:/ui/FragsPage.qml"
            } else if ("todos" === name) {
                pages.source = "qrc:/ui/TodosPage.qml"
            } else if ("file-box" === name) {
                pages.source = "qrc:/ui/FileBoxPage.qml"
            }
        }
    }

    Component.onCompleted: CxNetwork.enableHttps(true)

    Connections {
        target: Sys

        function onNotify(reason) {
            // double clicked & global shortcut & active by run
            if (reason === 2 || reason === 5 || reason === 6) {
                window.showWindow()
            }
        }
    }

    Connections {
        id: loginPageConnection
        target: null
        function onLogin(ok) {
            window.loadPage(naviBar.currentPageName)
        }
    }

    Connections {
        id: homePageConnection
        target: null

        function onBackToLogin() {
            window.loadPage("login")
        }
    }


    Ui.NaviBar {
        id: naviBar
        height: window.height

        onCurrentPageNameChanged: {
            // check login
            window.loadPage(currentPageName)
        }

        onOtherButtonClicked: {
            if ("settings" === name) {
                settings.open()
            }
        }
    }

    Item {
        id: mainItem
        width: window.width - naviBar.width
        x: naviBar.width
        height: window.height

        Loader {
            id: pages
            anchors.fill: parent
            source: "qrc:/ui/HomePage.qml"
        }


        Popup {
            id: settings

            width: Math.min(mainItem.width * 0.9, 800)
            height: Math.min(mainItem.height * 0.9, 600)
            anchors.centerIn: mainItem
            dim: true

            ScrollView {
                anchors.fill: parent
                clip: true

                Ui.SettingsPage {
                    implicitWidth: parent.width
                }
            }
        }
    }

}
