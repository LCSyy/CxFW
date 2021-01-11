import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import CxQuick 0.1 as Cx
import "Quick" as Cx
import "Controls" as Cx
import "Scripts/cxfw.js" as Js
import "qml" as Todos

ApplicationWindow {
    id: app
    flags: Qt.Tool
    title: qsTr("Todos")
    width: 302
    height: 500
    minimumWidth: 240
    minimumHeight: 380
    maximumWidth: 400
    maximumHeight: 600
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

    function mouseClickMapToListViewIndex(mouseArea, listView, mouse) {
        const p = mouseArea.mapToItem(listView,mouse.x,mouse.y);
        const idx = listView.indexAt(p.x+listView.contentX, p.y+listView.contentY);
        return idx;
    }

    function showWindow() {
        app.showNormal()
        app.raise()
        app.requestActivate()
    }

    Component.onCompleted: {
        Cx.Network.enableHttps();
        tasksModel.load();
        todosModel.load(tType,0);
    }

    Todos.Settings {
        id: appSettings
    }

    QtObject {
        id: urls

        function todoItems() {
            return "https://<host>:<port>/api/todos/"
            .replace("<host>",appSettings.host)
            .replace("<port>", appSettings.port)
        }

        function todoTasks() {
            return "https://<host>:<port>/api/todos/tasks/"
            .replace("<host>",appSettings.host)
            .replace("<port>", appSettings.port)
        }
    }

    Connections {
        target: Cx.Sys

        function onSystemNotify(reason) {
            // double clicked & global shortcut
            if (reason === 2 || reason === 5) {
                app.showWindow()
            }
        }
    }

    Connections {
        id: newTodoConnection
        target: null
        function onOk(id) {
            todosModel.load(app.tType, taskCombo.currentValue);
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

    footer: Button {
        id: settingsBtn
        text: qsTr("Settings")
        onClicked: appSettings.open()
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
                width: parent.width - taskBtn.width - parent.spacing
                model: tasksModel
                textRole: "title"
                valueRole: "id"
                currentIndex: 0

                onCurrentIndexChanged: {
                    todosModel.load(app.tType, tasksModel.get(currentIndex).id);
                }
            }
            Button {
                id: taskBtn
                text: qsTr("Tasks")
                onClicked: {
                    var p = taskComponent.createObject(app);
                    p.open();
                }
            }
        }

        Button {
            id: newTodoBtn
            text: qsTr("New Todo")
            width: parent.width
            onClicked: {
                var p = newComponent.createObject(app);
                newTodoConnection.target = p;
                p.open();
            }
        }

        ListView {
            id: todosView
            width: parent.width
            height: parent.height - taskCombo.height - newTodoBtn.height - parent.spacing * 2
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
                    visible: (0 < model.importance && model.importance <= 7) ? true : false
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
                    visible:(0 < model.urgency && model.urgency <= 7) ? true : false
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

            MouseArea {
                acceptedButtons: Qt.RightButton
                anchors.fill: parent
                onClicked: {
                    const idx = app.mouseClickMapToListViewIndex(this, todosView, mouse);
                    todosView.currentIndex = idx;
                    if (idx !== -1) {
                        itemMenu.popup();
                        mouse.accepted = true;
                    }
                }

                Menu {
                    id: itemMenu

                    Action {
                        text: qsTr("Remove")
                        onTriggered: {
                            mask.showMask();
                            const todoID = todosModel.get(todosView.currentIndex).id;
                            Cx.Network.del(urls.todoItems() + todoID, appSettings.basicAuth(), (resp)=>{
                                               todosModel.load(app.tType, taskCombo.currentValue);
                                               mask.hideMask();
                                               banner.show("Data removed !");
                                           });
                        }
                    }
                }
            }
        }
    }

    Component {
        id: newComponent

        Cx.Popup {
            id: popup

            signal ok(int id)
            property bool changed: false
            property int todoID: 0

            closePolicy: Popup.NoAutoClose
            implicitWidth: {
                var dw = parent.width * 0.95;
                if (dw > 800) { dw = 800; }
                return dw;
            }
            implicitHeight: parent.height * 0.95

            Cx.ListModel {
                id: tasksModel
                roleNames: ["id","title","created_at","remark"]
                Component.onCompleted: load()

                function load() {
                    mask.showMask();
                    Cx.Network.get(urls.todoTasks(),
                                   appSettings.basicAuth(),
                                   (resp)=>{
                                       tasksModel.clear();
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

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Cx.Theme.baseMargin
                    anchors.rightMargin: Cx.Theme.baseMargin

                    Button {
                        text: qsTr("Save")
                        onClicked: {
                            mask.showMask();

                            const content = textArea.text.trim()

                            const dt = (new Date(deadLineField.text.trim()).format("yyyy-MM-ddThh:mm:ss+zz:00"));
                            const importance = importanceCombo.currentIndex <= 6 ? (importanceCombo.currentIndex + 1) : 0;
                            const urgency = urgencyCombo.currentIndex <= 6 ? (urgencyCombo.currentIndex + 1) : 0;
                            const data = {
                                id: popup.todoID,
                                task_id: taskCombo.currentValue,
                                title: Js.getFirstLine(content),
                                content: content,
                                importance: importance,
                                urgency: urgency,
                                dead_line: dt,
                            };

                            if (data.id <= 0) {
                                Cx.Network.post(urls.todoItems(), appSettings.basicAuth(), data, (resp)=>{
                                                    try {
                                                        const r = JSON.parse(resp);
                                                        const body = r.body;
                                                        popup.todoID = body.id;
                                                        popup.changed = false;
                                                        popup.ok(popup.todoID);
                                                    } catch(e) {
                                                        console.log(e);
                                                    }
                                                   mask.hideMask();
                                                   banner.show("Data saved !");
                                               });
                            } else {
                                Cx.Network.put(urls.todoItems() + data.id, appSettings.basicAuth(), data, (resp)=>{
                                                   try {
                                                       const r = JSON.parse(resp);
                                                       const body = r.body;
                                                       popup.todoID = body.id;
                                                       popup.changed = false;
                                                       popup.ok(popup.todoID);
                                                   } catch(e) {
                                                       console.log(e);
                                                   }
                                                   mask.hideMask();
                                                   banner.show("Data saved !");
                                               });
                            }
                        }
                    }

                    Button {
                        text: qsTr("Remove")
                        onClicked: {
                            mask.showMask();
                            Cx.Network.del(urls.todoTasks() + popup.todoID, appSettings.basicAuth(), (resp)=>{
                                               popup.todoID = 0;
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
                    anchors.margins: Cx.Theme.baseMargin

                    ComboBox {
                        id: taskCombo
                        Layout.fillWidth: true
                        height: Cx.Theme.contentHeight
                        model: tasksModel
                        textRole: "title"
                        valueRole: "id"
                        currentIndex: 0
                    }

                    TextField {
                        id: deadLineField
                        Layout.fillWidth: true
                        text: (new Date).format("yyyy-MM-dd hh:mm:ss")
                    }

                    Row {
                        Layout.fillWidth: true
                        spacing: 4
                        ComboBox {
                            width: (parent.width - parent.spacing) / 2
                            id: importanceCombo
                            model: ["1","2","3","4","5","6","7","不重要"]
                            currentIndex: 7
                        }
                        ComboBox {
                            id: urgencyCombo
                            width: (parent.width - parent.spacing) / 2
                            model: ["1","2","3","4","5","6","7","不紧急"]
                            currentIndex: 7
                        }
                    }

                    TextArea {
                        id: textArea
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        wrapMode: appSettings.contentLineWrap === true ? TextArea.WrapAnywhere : TextArea.NoWrap
                        selectByMouse: true
                        font.pointSize: app.font.pointSize + 2
                        Cx.SyntaxHighlighter {
                            target: textArea.textDocument
                        }

                        onTextChanged: {
                            popup.changed = true
                        }

                        background: Rectangle {
                            implicitWidth: 100
                            implicitHeight: 100
                            color: "white"
                        }
                    }
                }
            }

            footer: Text {
                id: createdAtField
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

        Cx.Popup {
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

    Cx.Banner {
        id: banner
        x: visible ? app.width - implicitWidth - 4 : app.width + 4
        y: app.height - implicitHeight - 4
    }

    Cx.Mask {
        id: mask
        anchors.fill: parent
         maskItem: app.contentItem
    }

}
