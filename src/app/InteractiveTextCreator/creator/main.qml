import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import IT 1.0

ApplicationWindow {
    id: app
    visible: true
    minimumWidth: 320
    maximumWidth: 320
    minimumHeight: 600
    maximumHeight: 600
    title: qsTr("Hello World")
    color: "#ACBDCF"

    TrendsBoardModel {
        id: trendsBoardModel
        objectName: "trendsBoardModel"
    }

    ListModel {
        id: complicatedModel

        ListElement {
            comp: "one"
            height: 100
        }

        ListElement {
            comp: "two"
            height: 150
        }

        ListElement {
            comp: "three"
            height: 50
        }

        ListElement {
            comp: "two"
            height: 150
        }

        ListElement {
            comp: "three"
            height: 50
        }

        ListElement {
            comp: "one"
            height: 100
        }

        ListElement {
            comp: "two"
            height: 150
        }
        ListElement {
            comp: "two"
            height: 150
        }

        ListElement {
            comp: "three"
            height: 50
        }

        ListElement {
            comp: "two"
            height: 150
        }
    }

    ListModel {
        id: userInfoModel
        ListElement {
            color: "#903785"
        }

        ListElement {
            color: "#ACDBFF"
        }
    }

    SwipeView {
        anchors.fill: parent
        interactive: false
        currentIndex: tabBar.currentIndex

        ListView {
            id: boardView
            spacing: 8
            boundsBehavior: ListView.StopAtBounds
            model: trendsBoardModel

            delegate: Rectangle {
                width: boardView.width
                height: 100
                color: "#FCFCFC"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16
                    Text {
                        Layout.fillWidth: true
                        text: model.title
                        elide: Text.ElideRight
                        font.bold: true
                        font.pointSize: app.font.pointSize + 4
                    }

                    Text {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                        elide: Text.ElideRight
                        text: model.brief
                        font.pointSize: app.font.pointSize + 2
                    }
                }
            }
        }

        ListView  {
            id: storeView
            boundsBehavior: ListView.StopAtBounds
            model: complicatedModel
            delegate:  Loader {
                width: storeView.width
                height: model.height
                sourceComponent: {
                    if (model.comp === "one") {
                        return one
                    } else if (model.comp === "two") {
                        return two;
                    } else if (model.comp === "three") {
                        return three;
                    } else {
                        return undefined;
                    }
                }
            }
        }

        ListView {
            id: userInfoView
            boundsBehavior: ListView.StopAtBounds
            spacing: 8
            model: userInfoModel
            delegate: Rectangle {
                width: userInfoView.width
                height: 50
                color: "white"
            }
        }
    }

    footer: TabBar {
        id: tabBar
        width: parent.width
        TabButton {
            text: "Books"
        }
        TabButton {
            text:"Store"
        }
        TabButton {
            text: "Me"
        }
    }

    Component {
        id: readComponent
        Rectangle {
            x: (app.width - width) / 2
            width: app.width / 2
            height: parent.height
            color: "white"
            ScrollView {
                anchors.fill: parent
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                // ScrollBar.vertical.snapMode: ScrollBar.SnapAlways

                TextArea {
                    readOnly: true
                    font.pointSize: app.font.pointSize + 4
                    wrapMode: TextArea.WrapAtWordBoundaryOrAnywhere
                    text: ""
                }
            }
        }
    }

    Component {
        id: one
        Rectangle {
            color: "#342453"
        }
    }

    Component {
        id: two
        Rectangle {
            color: "#254477"
        }
    }

    Component {
        id: three
        Rectangle {
            color: "#346675"
        }
    }
}
