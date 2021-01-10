import QtQuick 2.15
import QtQuick.Controls 2.15
import CxQuick 0.1 as Cx
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.1

import "Qml" as CxUi

ApplicationWindow {
    id: app
    title: qsTr("Todos")
    width: 300
    height: 500
    visible: true

    property int tType: 0

    function levelColor(level) {
        switch (level) {
        case 1:
            return "#ee3f4d"; // 茶花红
        case 2:
            return "#E9967A";
        case 3:
            return "#fed71a";
        case 4:
            return "#985642";
        case 5:
            return "#789465";
        case 6:
            return "#859764";
        }
        return "#FAFAFA"
    }

    Component.onCompleted: {
        Cx.Network.enableHttps();
        tasksModel.load();
        todosModel.load(tType,0);
    }


    Settings {
        id: appSettings
        property bool contentLineWrap: true
        property int contentFontPointSize: app.font.pointSize
        property string host: "localhost"
        property int port: 8081
        property string basicAuthKey: "CxFw.Liu"
        property string basicAuthValue: "9dc68cfbabc30fdfcc954eeb483c286016e94a8a"

        function basicAuth() {
            var auth = {
//                "Authorization": basicAuthKey + ":" + basicAuthValue,
                "Authorization": "CxFw.Liu:9dc68cfbabc30fdfcc954eeb483c286016e94a8a",
            };
            return auth;
        }
    }

    QtObject {
        id: urls

        function todoItems() {
//            return "https://<host>:<port>/api/todos/"
//            .replace("<host>",appSettings.host)
//            .replace("<port>", appSettings.port)
            return "https://<host>:<port>/api/todos/items/"
            .replace("<host>",appSettings.host)
            .replace("<port>", 8081)
        }

        function todoTasks() {
//            return "https://<host>:<port>/api/todos/tasks/"
//            .replace("<host>",appSettings.host)
//            .replace("<port>", appSettings.port)
            return "https://<host>:<port>/api/todos/tasks/"
            .replace("<host>", appSettings.host)
            .replace("<port>", 8081)
        }
    }



    Cx.ListModel {
        id: tasksModel
        roleNames: ["id","title","created_at","remark"]

        function load() {
            mask.showMask();
            Cx.Network.get(urls.todoTasks(),
                           appSettings.basicAuth(),
                           (resp)=>{
                               tasksModel.clear();
                               tasksModel.append({id:0,title:"所有",created_at:"",remark:""});
                               try {
                                   const r = JSON.parse(resp)
                                   const body = r.body || [];
                                   for (var i in body) {
                                       tasksModel.append(body[i]);
                                   }
                               } catch(e) {
                                   console.log(JSON.stringify(e));
                               }
                               mask.hideMask();
                           });
        }
    }

    Cx.ListModel {
        id: todosModel
        roleNames: ["id", "task_id", "title", "content", "dead_line", "importance", "urgency"]

        function load(watchType, taskID) {
            mask.showMask();

            const query = "?dimen={0}&task={1}".replace("{0}",watchType).replace("{1}", taskID)
            Cx.Network.get(urls.todoItems() + query, appSettings.basicAuth(), (resp)=>{
                               todosModel.clear();
                               try {
                                   const r = JSON.parse(resp)
                                   const body = r.body || [];
                                   for (var i in body) {
                                       var row = body[i];
                                       const d = new Date(row.dead_line);
                                       row.dead_line = d.toLocaleString()
                                       todosModel.append(body[i]);
                                   }
                               } catch(e) {
                                   console.log(JSON.stringify(e));
                               }
                               mask.hideMask();
                           });
        }
    }

    header: Button {
        id: typeBtn
        text: app.tType === 0 ? qsTr("Importance") : qsTr("Urgency")
        onClicked: {
            app.tType = (app.tType === 0 ? 1 : 0);
            todosModel.load(app.tType, taskCombo.currentValue);
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Row {
            width: parent.width
            spacing: 4
            ComboBox {
                id: taskCombo
                height: parent.height
                width: parent.width - newBtn.width - parent.spacing
                model: tasksModel
                textRole: "title"
                valueRole: "id"
                currentIndex: 0

                onCurrentIndexChanged: {
                    todosModel.load(app.tType, tasksModel.get(currentIndex).id);
                }
            }
            Button {
                id: newBtn
                text: qsTr("New")
                onClicked: {
                    var p = newComponent.createObject(app);
                    p.open();
                }
            }
        }

        ListView {
            width: parent.width
            height: parent.height - taskCombo.height - parent.spacing
            clip: true
            spacing: 8
            model: todosModel
            delegate: Rectangle {
                width: parent === null ? 0 : parent.width
                height: titleField.contentHeight + titleField.topPadding + titleField.bottomPadding
                        + deadLineField.contentHeight + deadLineField.topPadding + deadLineField.bottomPadding
                color: "#93b5cf" // 星蓝

                Text {
                    id: titleField
                    padding: 16
                    text: model.title
                    width: parent.width - importanceDimen.width - rightPadding
                    font.pointSize: app.font.pointSize + 4
                    font.bold: true
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                }

                Text {
                    id: deadLineField
                    anchors.top: titleField.bottom
                    padding: 8
                    leftPadding: 16
                    text: qsTr("截止日期：%1").arg(model.dead_line)
                }

                Rectangle {
                    id: importanceDimen
                    width: 20
                    height: 20
                    radius: 10
                    color: app.levelColor(model.importance)
                    visible: model.importance <= 7 ? true : false
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.margins: 16
                    Text {
                        anchors.fill: parent
                        text: model.importance
                        verticalAlignment: Qt.AlignVCenter
                        horizontalAlignment: Qt.AlignHCenter
                    }
                }

                Rectangle {
                    id: urgencyDiemn
                    width: 20
                    height: 20
                    anchors.top: importanceDimen.bottom
                    radius: 10
                    color: app.levelColor(model.urgency)
                    visible: model.urgency <= 7 ? true : false
                    anchors.right: parent.right
                    anchors.margins: 16
                    Text {
                        anchors.fill: parent
                        text: model.urgency
                        verticalAlignment: Qt.AlignVCenter
                        horizontalAlignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }

    Component {
        id: newComponent

        CxUi.Popup {
            id: popup

            signal ok(int id)
            property bool changed: false

            closePolicy: Popup.NoAutoClose
            implicitWidth: {
                var dw = parent.width * 0.95;
                if (dw > 800) { dw = 800; }
                return dw;
            }
            implicitHeight: parent.height * 0.95

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Cx.Theme.baseMargin
                    anchors.rightMargin: Cx.Theme.baseMargin

                    Button {
                        text: qsTr("Save")
                    }

                    Button {
                        text: qsTr("Remove")
                        onClicked: {
                            mask.showMask();
                            Cx.Network.del(urls.postsUrl() + popup.postID, appSettings.basicAuth(), (resp)=>{
                                               popup.postID = 0;
                                               popup.ok(0);
                                               popup.close();
                                               mask.hideMask();
                                               banner.show("Data removed !");
                                           });
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Button {
                        text: qsTr("Close")
                        onClicked: {
                            if (popup.changed) {
                                var pp = changeAlertComponent.createObject(popup.contentItem)
                                exitConnection.target = pp;
                                pp.open();
                            } else {
                                popup.close();
                            }
                        }
                    }
                }
            }

            body: Item {
                implicitWidth: 100
                implicitHeight: 100
                ColumnLayout {
                    anchors.fill: parent

                    Row {
                        Layout.fillWidth: true
                        Layout.margins: 8
                        spacing: 4
                        ComboBox {
                            id: taskCombo
                            height: parent.height
                            width: parent.width - newBtn.width - parent.spacing
                            model: tasksModel
                            textRole: "title"
                            valueRole: "id"
                            currentIndex: 0
                        }
                        Button {
                            id: newBtn
                            text: qsTr("New Task")
                        }
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        TextArea {
                            id: textArea
                            wrapMode: appSettings.contentLineWrap === true ? TextArea.WrapAnywhere : TextArea.NoWrap
                            selectByMouse: true
                            font.pointSize: appSettings.contentFontPointSize
                            leftPadding: Cx.Theme.baseMargin * 2
                            rightPadding: Cx.Theme.baseMargin * 2

                            Cx.SyntaxHighlighter {
                                target: textArea.textDocument
                            }

                            onTextChanged: {
                                popup.changed = true
                            }
                        }
                    }
                }
            }

            footer: Text {
                id: createdAtField
//                height: 25 + padding * 2
                padding: Cx.Theme.baseMargin
                horizontalAlignment: Qt.AlignRight
            }

            Connections {
                id: exitConnection
                target: null

                function onAccept() {
                    actionSave.trigger();
                }

                function onReject() {
                    popup.close();
                }
            }
        }
    }

    Component {
        id: changeAlertComponent

        CxUi.Popup {
            id: popup
            implicitWidth: 300
            implicitHeight: 200

            signal accept();
            signal reject();

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Cx.Theme.baseMargin
                    anchors.rightMargin: Cx.Theme.baseMargin

                    Button {
                        text: qsTr("Save")
                        onClicked: {
                            popup.accept();
                            popup.close();
                        }
                    }

                    Button {
                        text: qsTr("Not Save")
                        onClicked: {
                            popup.reject();
                            popup.close();
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Button {
                        text: qsTr("Close")
                        onClicked: {
                            popup.close();
                        }
                    }
                }
            }

            body: Item {
                implicitWidth: 150
                implicitHeight: 100
                Text {
                    anchors.centerIn: parent
                    font.pointSize: app.font.pointSize + 2
                    text: qsTr("Content changed. Save it or not ?")
                }
            }
        }
    }

    CxUi.Banner {
        id: banner
        x: visible ? app.width - implicitWidth - 4 : app.width + 4
        y: app.height - implicitHeight - 4
    }

    CxUi.Mask {
        id: mask
        anchors.fill: parent
        maskItem: app.contentItem
    }

}
