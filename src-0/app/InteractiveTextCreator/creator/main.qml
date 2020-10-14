import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import IT 1.0
import "qml" as App

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

    SwipeView {
        anchors.fill: parent
        interactive: false
        currentIndex: tabBar.currentIndex

        App.ListView {
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

            onItemClicked: {
                console.log(idx)
            }
        }

        App.ListView  {
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
            onItemClicked: {
                var incubator = detailPage.incubateObject(app)
                if (incubator.status !== Component.Ready) {
                     incubator.onStatusChanged = function(status) {
                         if (status === Component.Ready) {
                             incubator.object.text = idx
                         }
                     }
                 } else {
                    incubator.object.text = idx
                 }
            }
        }

        App.UserCenter {
            onItemClicked: {
                console.log(idx)
            }
        }
    }

    footer: TabBar {
        id: tabBar
        width: parent.width
        TabButton {
            text: "Trends"
        }
        TabButton {
            text:"Center"
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

    Component {
        id: detailPage

        Page {
            id: page
            property alias text: content.text

            header: ToolBar {
                RowLayout {
                    ToolButton {
                        Layout.fillHeight: true
                        Layout.alignment: Qt.AlignLeft
                        width: 50
                        text: "Back"
                        onClicked: {
                            page.destroy()
                        }
                    }
                }
            }

            background: Rectangle {
                color: "white"
                implicitWidth: page.parent.width
                implicitHeight: page.parent.height
            }

            contentItem: Text {
                id: content
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: app.font.pointSize + 5
                font.bold: true
            }
        }
    }
}
