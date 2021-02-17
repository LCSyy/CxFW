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

    Connections {
        target: Sys

        function onNotify(reason) {
            // double clicked & global shortcut & active by run
            if (reason === 2 || reason === 5 || reason === 6) {
                window.showWindow()
            }
        }
    }

    Ui.NaviBar {
        id: naviBar
        height: window.height

        onCurrentPageNameChanged: loadPage(currentPageName)

        onOtherButtonClicked: {
            if ("settings" === name) {
                settings.open()
            }
        }

        function loadPage(name) {
            if ("home" === name) {
                pages.source = "qrc:/ui/HomePage.qml"
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

    Item {
        id: mainItem
        width: window.width - naviBar.width
        x: naviBar.width
        height: window.height

        Loader {
            id: pages
            anchors.fill: parent
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
