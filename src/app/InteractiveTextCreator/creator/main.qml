import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: app
    visible: true
    minimumWidth: 320
    maximumWidth: 320
    minimumHeight: 600
    maximumHeight: 600
    title: qsTr("Hello World")
    color: "#ACBDCF"

    ListModel {
        id: boardModel

        ListElement {
            uid: 1; name: "news-2432"; title: "新发布"; brief: "有作者发布了新的作品。快去看看吧！"
        }
        ListElement {
            uid: 2; name: "user-343-update"; title: "日常更新 - 落日余晖"; brief: "终于又更新了。。。"
        }
        ListElement {
            uid: 3; name: "alert-335"; title: "公告"; brief: "关于作者行为守则，请阅读。"
        }
        ListElement {
            uid: 4; name: "new-journey"; title: "落日余晖 - 第三章"; brief: "夫志，心笃行之术。\n长没长于博谋，安没安于忍辱，先没先于修德，乐没乐于好善，\n神没神于至诚，明没明于体物，吉没吉于知足，苦没苦于多愿，\n悲没悲于精散，病没病于无常，短没短于苟得，幽没幽于贪鄙，\n孤没孤于自恃，危没危于任疑，败没败于多私。"
        }
        ListElement {
            uid: 5; name: "new-story-up"; title: "新的故事接龙"; brief: "创作者【易秋水】开启了新的故事接龙《游船》。前往查看吧。"
        }
        ListElement {
            uid: 5; name: "edit-story-up"; title: "新的接龙1"; brief: "【不夜】接受了《游船》的接龙挑战。"
        }
        ListElement {
            uid: 5; name: "edit-story-up-2"; title: "新的接龙2"; brief: "【易秋水】续写了《游船》。快去阅读新章节吧。"
        }
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
            model: boardModel

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
