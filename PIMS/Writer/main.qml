import QtQml.Models 2.15
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.LocalStorage 2.15
import Qt.labs.settings 1.1

import CxQuick 0.1 as Cx
import "qml" as App
import "js/app.js" as Js

// status:
//   trash
//   draft
//   release
//   protect
//   ...

ApplicationWindow {
    id: app
    width: 1000
    height: 720
    visible: true
    title: qsTr("Writer")

    Component.onCompleted: {
        Cx.Network.enableHttps(true);
    }

    function showWindow() {
        app.showNormal()
        app.raise()
        app.requestActivate()
    }

    Settings {
        id: appSettings
        property bool contentLineWrap: true
        property int contentFontPointSize: app.font.pointSize
        property string host: "localhost"
        property int port: 80
    }

    QtObject {
        id: status

        readonly property int stActive: 0 // 激活
        readonly property int stInActive: 1 // 未激活
        readonly property int stInValid: 2 // 失效
        readonly property int stTrash: 3 // 删除
    }

    QtObject {
        id: urls

        function postsUrl() {
            return "https://<host>:<port>/api/posts/"
            .replace("<host>",appSettings.host)
            .replace("<port>", appSettings.port)
        }

        function tagsUrl() {
            return "https://<host>:<port>/api/tags/"
            .replace("<host>",appSettings.host)
            .replace("<port>", appSettings.port)
        }
    }

    Connections {
        target: Cx.App

        function onSystemTrayIconActivated(reason) {
            if (reason === 2) { // double clicked
                app.showWindow()
            }
        }
    }

    Cx.GlobalShortcut {
        sequence: "Shift+w"
        onActivated: {
            app.showWindow()
        }
    }

    App.MainPage {
        id: mainPage
        anchors.fill: parent

        header: App.ToolBar {
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Cx.Theme.baseMargin
                anchors.rightMargin: Cx.Theme.baseMargin
                anchors.bottomMargin: 2

                App.Button { action: actionNew }
                App.Button { action: actionTags }
                App.Button { action: actionTrash }
                App.Button { action: actionSettings }
                App.Button { action: actionBacktoHome }
                Item { Layout.fillWidth: true }
                App.TextField {
                    visible: false
                    placeholderText: qsTr('Search')
                }
                App.Button { action: actionRefresh }
            }

            Rectangle {
                width: parent.width
                anchors.bottom: parent.bottom
                height:1
                color: Cx.Theme.bgDeepColor
            }
        }

        footer: App.StatusBar {
             visible: false
            RowLayout {
                anchors.fill: parent
                anchors.margins: 0
                anchors.rightMargin: Cx.Theme.baseMargin / 2
                anchors.leftMargin: Cx.Theme.baseMargin / 2

                Item {
                    Layout.fillWidth: true
                }

                App.Button {
                    text: qsTr("Already Sync")
                }
            }
        }

        SplitView {
            anchors.fill: parent
            orientation: Qt.Horizontal

            ListView {
                id: contentListView
                SplitView.fillWidth: true
                SplitView.fillHeight: true

                clip: true

                model: contentsModel

                delegate: Item {
                    width: contentListView !== null ? contentListView.width : 0
                    height: 35

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.bottomMargin: 1
                        textFormat: Text.RichText
                        verticalAlignment: Qt.AlignVCenter
                        font.pointSize: app.font.pointSize + 2

                        text: {
                            var str = '<a href="%1">%2</a>'.replace('%1',model.id)
                            str = str.replace('%2',model.title)
                            return '<small>%1 - </small>'.replace('%1',model.updated_at) + '<b>%1</b>'.replace('%1',str)
                        }

                        onLinkActivated: {
                            var pp = contentComponent.createObject(app);
                            contentConnection.target = pp;
                            pp.edit(link);
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width - Cx.Theme.baseMargin * 2
                        height: 1
                        x: Cx.Theme.baseMargin
                        color: Cx.Theme.bgNormalColor
                    }
                }
            }

            Column {
                SplitView.preferredWidth: 150
                SplitView.maximumWidth:  parent.width / 3
                SplitView.minimumWidth: 100
                SplitView.fillHeight: true

                Rectangle {
                    width: parent.width
                    height: 25
                    color: Cx.Theme.bgNormalColor
                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        verticalAlignment: Qt.AlignVCenter
                        text: qsTr('Categories')
                    }
                }

                ListView {
                    id: tagsView
                    width: parent.width
                    height: parent.height - 25
                    clip: true
                    currentIndex: 0

                    model: tagsModel

                    onCurrentIndexChanged: {
                        if (tagsView.currentIndex === 0) {
                            contentsModel.update([]);
                        } else if (tagsView.currentIndex !== -1) {
                            const row = tagsModel.get(tagsView.currentIndex);
                            if (row !== undefined) {
                                contentsModel.update([row.id]);
                            }
                        }
                    }

                    delegate: Rectangle {
                        width: parent === null ? 0 : parent.width
                        height: Cx.Theme.contentHeight
                        color: model.index === tagsView.currentIndex ? Cx.Theme.bgLightColor : "white"
                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: 8
                            verticalAlignment: Qt.AlignVCenter
                            text: model.title
                            font.pointSize: app.font.pointSize + 2
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            const p = mapToItem(tagsView,mouse.x,mouse.y);
                            tagsView.currentIndex = tagsView.indexAt(p.x+tagsView.contentX, p.y+tagsView.contentY);
                        }
                    }
                }
            }
        }
    }

    Action {
        id: actionNew
        text: qsTr('New')
        shortcut: StandardKey.New
        onTriggered: {
            var pp = contentComponent.createObject(app);
            contentConnection.target = pp;
             const tag = tagsModel.get(tagsView.currentIndex);
             if(tag.name !== "_all_") {
                 pp.setDefaultTag(tag);
             }
            pp.open();
        }
    }

    Action {
        id: actionTags
        text: qsTr("Tags")
        onTriggered: {
            var pp = tagsComponent.createObject(app);
            tagNewConnection.target = pp;
            pp.open();
        }
    }

    Action {
        id: actionTrash
        text: qsTr("Trash")
        onTriggered: {
            var pp = trashComponent.createObject(app);
            contentConnection.target = pp;
            pp.open();
        }
    }

    Action {
        id: actionSettings
        text: qsTr("Settings")
        onTriggered: {
            var pp = settingsComponent.createObject(app)
            pp.open();
        }
    }

    Action {
        id: actionRefresh
        text: qsTr("Refresh")
        onTriggered: {
            tagsModel.update();
        }
    }

    Action {
        id: actionBacktoHome
        text: qsTr("Home")
        onTriggered: {
            homePage.visible = true
        }
    }

    Connections {
        id: contentConnection
        target: null

        function onOk(id) {
            const oldIdx = tagsView.currentIndex;
            tagsView.currentIndex = -1;
            tagsView.currentIndex = oldIdx;
        }
    }

    Connections {
        id: tagNewConnection
        target: null

        function onOk(tagID, tagTitle) {
            tagsModel.update();
        }
    }

    Cx.ListModel {
        id: contentsModel
        roleNames: ["id","title","created_at","updated_at"]

        Component.onCompleted: {
            update();
        }

        function update(tags) {
            mask.showMask();

            var tagQuery = "?";
            if (tags !== undefined) {
                for (var i in tags) {
                    tagQuery += ("tag=" + tags[i] + "&")
                }
            }
            Cx.Network.get(urls.postsUrl() + tagQuery,(resp)=>{
                               contentsModel.clear();
                               try {
                                   const res = JSON.parse(resp);
                                   const body = res.body || [];
                                   for (var i in body) {
                                       var date = new Date(body[i].updated_at)
                                       body[i].updated_at = date.toLocaleString(Qt.locale(),Locale.LongFormat)
                                       contentsModel.append(body[i]);
                                   }
                               } catch(e) {
                                   console.log(e)
                               }
                               mask.hideMask();
                           });
        }
    }

    Cx.ListModel {
        id: tagsModel
        roleNames: ["id","title","created_at"]
        Component.onCompleted: {
            update();
        }

        function update() {
            mask.showMask();
            Cx.Network.get(urls.tagsUrl(),(resp)=>{
                               const oldIdx = tagsView.currentIndex
                               clear();
                               this.append({name:"_all_", title:"全部"});
                               try {
                                   const res = JSON.parse(resp);
                                   const body = res.body;
                                   for (var i in body) {
                                       var row = body[i];
                                       tagsModel.append(row);
                                   }
                               } catch(e) {
                                   console.log(e);
                               }
                               tagsView.currentIndex = oldIdx
                               mask.hideMask();
                           });
        }
    }

    Component {
        id: contentComponent

        App.Popup {
            id: popup
            closePolicy: Popup.NoAutoClose

            implicitWidth: {
                var dw = parent.width * 0.8;
                if (dw > 800) { dw = 800; }
                return dw;
            }
            implicitHeight: parent.height * 0.95

            property bool editable: true
            signal ok(int id)

            QtObject {
                id: meta
                property int id: 0
                property bool changed: false
                property App.Popup tagEditor: null

                function reset() {
                    id = 0;
                    changed = false;
                }
            }

            function edit(postID) {
                mask.showMask();
                Cx.Network.get(urls.postsUrl() + postID, (resp)=>{
                               try {
                                   const res = JSON.parse(resp);
                                   const body = res.body;
                                   const tags = body.tags || [];
                                   meta.id = body.id;
                                   textArea.text = body.content;
                                   for(var i in tags){
                                       tagRepeater.model.append(tags[i]);
                                   }
                                   popup.open();
                               } catch(e) {
                                   console.log(e);
                               }
                               mask.hideMask();
                           });
            }

            Connections {
                id: contentTagEditorCon
                target: null

                function onOk(tags) {
                    tagRepeater.model.clear();
                    for(var i = 0; i < tags.length; ++i){
                        tagRepeater.model.append(tags[i]);
                    }
                }

                function onLoaded() {
                    var tags = [];
                    for (var i = 0; i < tagRepeater.model.count(); ++i) {
                        tags.push(tagRepeater.model.get(i));
                    }
                    meta.tagEditor.setChecked(tags);
                    meta.tagEditor.visible = true;
                }
            }

            function setDefaultTag(tag) {
                tagRepeater.model.append(tag)
            }

            header: App.ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    App.Button {
                        visible: popup.editable
                        action: actionSave
                    }

                    App.Button {
                        visible: popup.editable
                        text: qsTr("Edit tags")
                        onClicked: {
                            meta.tagEditor = contentTagEditComponent.createObject(popup.contentItem);
                            contentTagEditorCon.target = meta.tagEditor;
                        }
                    }

                    App.Button {
                        visible: popup.editable
                        text: qsTr("Remove")
                        onClicked: {
                            mask.showMask();
                            Cx.Network.del(urls.postsUrl() + meta.id, (resp)=>{
                                               try {
                                                   const res = JSON.parse(resp);
                                                   if (res.err !== null) {
                                                       throw res.err;
                                                   }
                                                   meta.id = 0;
                                                   popup.ok(0);
                                                   popup.close();
                                               } catch(e) {
                                                   console.log(e);
                                               }
                                               mask.hideMask();
                                           });
                        }
                    }

                    App.Button {
                        visible: !popup.editable
                        text: qsTr("Recovery")
                        onClicked: {
                            mask.showMask();
                            Cx.Network.put(urls.postsUrl() + "status/" + meta.id + "?status=0",null,(resp)=>{
                                               try {
                                                   meta.id = 0;
                                                   popup.ok(0);
                                                   popup.close();
                                               }catch(e) {
                                                   console.log(e);
                                               }
                                               mask.hideMask();
                                           });
                        }
                    }

                    App.Button {
                        visible: !popup.editable
                        text: qsTr("Delete")
                        onClicked: {
                            mask.showMask();
                            Cx.Network.del(urls.postsUrl() + meta.id + "?del=1", (resp)=>{
                                               try {
                                                   const res = JSON.parse(resp);
                                                   if (res.err !== null) {
                                                       throw res.err;
                                                   }
                                                   meta.id = 0;
                                                   popup.ok(0);
                                                   popup.close();
                                               } catch(e) {
                                                   console.log(e);
                                               }
                                               mask.hideMask();
                                           });
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    App.Button {
                        text: qsTr("Close")
                        onClicked: popup.close()
                    }
                }
            }

            body: ColumnLayout {
                Flow {
                    Layout.fillWidth: true
                    Layout.topMargin: Cx.Theme.baseMargin / 2
                    spacing: Cx.Theme.baseMargin

                    Repeater {
                        id: tagRepeater
                        model: Cx.ListModel {
                            roleNames: ["id","title"]
                        }
                        delegate: App.Button {
                            text: model.title
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: Cx.Theme.bgDeepColor
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    TextArea {
                        id: textArea
                        readOnly: !popup.editable
                        wrapMode: appSettings.contentLineWrap === true ? TextArea.WrapAnywhere : TextArea.NoWrap
                        selectByMouse: true
                        font.pointSize: appSettings.contentFontPointSize

                        Cx.SyntaxHighlighter {
                            target: textArea.textDocument
                        }
                    }
                }
            }

            Action {
                id: actionSave
                text: qsTr("Save")
                // shortcut: StandardKey.Save
                onTriggered: {
                    if (textArea.text.trim() === '') { return; }
                    var obj = {
                        "id": meta.id,
                        "title": Js.getFirstLine(textArea.text),
                        "content": textArea.text,
                        "tags": [],
                    };

                    for (var i = 0; i < tagRepeater.model.count(); ++i) {
                        obj.tags.push(tagRepeater.model.get(i).id);
                    }

                    mask.showMask();
                    if (meta.id <= 0) {
                        Cx.Network.post(urls.postsUrl(), obj,(resp)=>{
                                           try {
                                               const res = JSON.parse(resp);
                                               const body = res.body;
                                               meta.id = body.id;
                                               textArea.text = body.content;
                                           } catch(e) {
                                               console.log(e);
                                           }
                                           popup.ok(meta.id)
                                           mask.hideMask();
                                       });
                    } else {
                        Cx.Network.put(urls.postsUrl(), obj,(resp)=>{
                                           try {
                                               const res = JSON.parse(resp);
                                               const body = res.body;
                                               meta.id = body.id;
                                               textArea.text = body.content;
                                           } catch(e) {
                                               console.log(e);
                                           }
                                           popup.ok(meta.id)
                                           mask.hideMask();
                                       });
                    }
                }
            }
        }
    }

    Component {
        id: tagsComponent

        App.Popup {
            id: popup
            implicitWidth: {
                var dw = parent.width * 0.8;
                if (dw > 640) { dw = 640; }
                return dw;
            }
            implicitHeight: parent.height * 0.8

            signal ok(int tagID, string tagTitle)

            header: App.ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    App.Button {
                        text: qsTr("New")
                        onClicked: {
                            var tag = tagEditComponent.createObject(popup.contentItem);
                            tagEditConn.target = tag;
                            tag.open();
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    App.Button {
                        text: qsTr("Close")
                        onClicked: popup.close()
                    }
                }
            }

            body: ListView {
                id: tagList
                clip: true

                model: Cx.ListModel {
                    id: tagModel
                    roleNames: ["id","title","created_at"]
                    Component.onCompleted: {
                        update();
                    }

                    function update() {
                        mask.showMask();
                        Cx.Network.get(urls.tagsUrl(),(resp)=>{
                                           clear();
                                           try {
                                               const res = JSON.parse(resp);
                                               const body = res.body;
                                               for (var i in body) {
                                                   var row = body[i];
                                                   tagModel.append(row);
                                               }
                                           } catch(e) {
                                               console.log(e);
                                           }
                                           mask.hideMask();
                                       });
                    }
                }

                delegate:  Item {
                    width: parent === null ? 0 : parent.width
                    height: 25

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.bottomMargin: 1
                        font.pointSize: app.font.pointSize + 2
                        textFormat: Qt.RichText
                        verticalAlignment: Qt.AlignVCenter
                        text: '<a href="%1">%2</a>'.replace("%1",model.id).replace("%2",model.title)

                        onLinkActivated: {
                            var tag = tagEditComponent.createObject(popup.contentItem);
                            tagEditConn.target = tag;
                            var row = {};
                            for (var i = 0; i < tagModel.count(); ++i) {
                                row = tagModel.get(i);
                                if (row.id === model.id) {
                                    break;
                                }
                            }
                            tag.edit(row);
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width - 16
                        height: 1
                        x: 8
                        color: Cx.Theme.bgNormalColor
                    }
                }
            }

            Connections {
                id: tagEditConn
                target: null

                function onOk(tagID, tagTitle) {
                    tagModel.update();
                    popup.ok(tagID,tagTitle);
                }
            }
        }
    }

    Component {
        id: trashComponent

        App.Popup {
            id: popup
            implicitWidth: {
                var dw = parent.width * 0.8;
                if (dw > 640) { dw = 640; }
                return dw;
            }
            implicitHeight: parent.height * 0.8

            signal ok(string uuid)

            header: App.ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    Item {
                        Layout.fillWidth: true
                    }

                    App.Button {
                        text: qsTr("Close")
                        onClicked: popup.close()
                    }
                }
            }

            body: ListView {
                id: trashView
                SplitView.fillWidth: true
                SplitView.fillHeight: true

                clip: true

                model: Cx.ListModel {
                    id: trashModel
                    roleNames: ["id","title","created_at","updated_at"]

                    Component.onCompleted: {
                        update([]);
                    }

                    function update(tags) {

                        mask.showMask();
                        var tagQuery = "?";
                        if (tags !== undefined) {
                            for (var i in tags) {
                                tagQuery += ("tag=" + tags[i] + "&")
                            }
                        }
                        Cx.Network.get(urls.postsUrl() + tagQuery + "status=" + status.stTrash,(resp)=>{
                                           trashModel.clear();
                                           try {
                                               const res = JSON.parse(resp);
                                               const body = res.body;
                                               for (var i in body) {
                                                   var date = new Date(body[i].updated_at)
                                                   body[i].updated_at = date.toLocaleString(Qt.locale(),Locale.LongFormat)
                                                   trashModel.append(body[i]);
                                               }
                                           } catch(e) {
                                               console.log(e)
                                           }
                                           mask.hideMask();
                                       });
                    }

                    function getData(id) {
                        for (var i = 0; i < count(); ++i) {
                            const item = get(i);
                            if (item.id === id) {
                                return item;
                            }
                        }
                        return null;
                    }
                }

                delegate: Item {
                    width: trashView.contentItem !== null ? trashView.contentItem.width : 0
                    height: 25

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.bottomMargin: 1
                        font.pointSize: app.font.pointSize + 2
                        textFormat: Text.RichText
                        verticalAlignment: Qt.AlignVCenter

                        text: {
                            var str = '<a href="%1">%2</a>'.replace('%1',model.id)
                            str = str.replace('%2',model.title)
                            return model.updated_at + ' - ' + str
                        }

                        onLinkActivated: {
                            var pp = contentComponent.createObject(app);
                            trashContentConnection.target = pp;
                            pp.editable = false;
                            pp.edit(link);
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width - Cx.Theme.baseMargin * 2
                        height: 1
                        x: Cx.Theme.baseMargin
                        color: Cx.Theme.bgNormalColor
                    }
                }
            }

            Connections {
                id: trashContentConnection
                target: null

                function onOk(id) {
                    popup.ok(id);
                    trashModel.update([]);
                }
            }
        }
    }

    Component {
        id: settingsComponent

        App.Popup {
            id: popup
            implicitWidth: {
                var dw = parent.width * 0.8;
                if (dw > 640) { dw = 640; }
                return dw;
            }
            implicitHeight: parent.height * 0.8

            header: App.ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Cx.Theme.baseMargin
                    anchors.rightMargin: Cx.Theme.baseMargin

                    App.Button {
                        text: qsTr("Save")
                        onClicked: {}
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    App.Button {
                        text: qsTr("Cancel")
                        onClicked: popup.close()
                    }
                }
            }

            body: GridLayout {
                columns: 2
                columnSpacing: Cx.Theme.baseMargin
                rowSpacing: Cx.Theme.baseMargin

                Label {
                    Layout.fillWidth: true
                    Layout.margins: Cx.Theme.baseMargin
                    Layout.columnSpan: 2
                    // horizontalAlignment: Qt.AlignHCenter
                    text: qsTr("Content Editor")
                    font.pointSize: app.font.pointSize + 4
                    font.bold: true
                }

                CheckBox {
                    Layout.columnSpan: 2
                    Layout.margins: Cx.Theme.baseMargin
                    text: qsTr("Line Wrap")
                    onCheckStateChanged: {
                        appSettings.contentLineWrap = (checkState === Qt.Checked);
                    }
                    Component.onCompleted: {
                        checkState = appSettings.contentLineWrap === true ? Qt.Checked : Qt.Unchecked;
                    }
                }

                Label {
                    text: qsTr("Font Point Size")
                    Layout.margins: Cx.Theme.baseMargin
                }

                ComboBox {
                    model: [9,10,11,12,13,14]
                    currentIndex: 0
                    onCurrentIndexChanged: {
                        appSettings.contentFontPointSize = parseInt(textAt(currentIndex))
                    }

                    Component.onCompleted: {
                        const curVal = appSettings.contentFontPointSize
                        for (var i = 0; i < count; ++i) {
                            if (textAt(i) === curVal.toString()) {
                                currentIndex = i;
                                break;
                            }
                        }
                    }
                }

                Label {
                    Layout.fillWidth: true
                    Layout.margins: Cx.Theme.baseMargin
                    Layout.columnSpan: 2
                    // horizontalAlignment: Qt.AlignHCenter
                    text: qsTr("Server")
                    font.pointSize: app.font.pointSize + 4
                    font.bold: true
                }

                Label {
                    text: qsTr("Host")
                    Layout.margins: Cx.Theme.baseMargin
                }

                TextField {
                    onEditingFinished: {
                        appSettings.host = text.trim();
                    }
                    Component.onCompleted: {
                        text = appSettings.host;
                    }
                }

                Label {
                    text: qsTr("Port")
                    Layout.margins: Cx.Theme.baseMargin
                }

                TextField {
                    onEditingFinished: {
                        appSettings.port = parseInt(text.trim());
                    }
                    Component.onCompleted: {
                        text = appSettings.port;
                    }
                }

                Item {
                    Layout.fillHeight: true
                    Layout.columnSpan: 2
                }
            }
        }
    }

    Component {
        id: tagEditComponent

        Dialog {
            id: tagEdit
            modal: true
            anchors.centerIn: parent
            padding: 8
            implicitWidth: 400
            implicitHeight: 300
            background: Rectangle {
                radius: 4
                border.width: 1
                border.color: Cx.Theme.bgDeepColor
            }
            onAccepted: {
                ok(meta.id,tagTitle.text);
                tagEdit.destroy();
            }
            onRejected: {
                tagEdit.destroy();
            }

            signal ok(int tagID, string tagTitle);

            function edit(row) {
                meta.id = row.id || 0;
                tagTitle.text = row.title;
                visible = true;
            }

            QtObject {
                id: meta
                property int id: 0
            }

            Page {
                anchors.fill: parent

                header: App.ToolBar {
                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        anchors.rightMargin: 8

                        App.Button {
                            text: qsTr("Save")
                            onClicked: {
                                mask.showMask();

                                const obj = {
                                    id: meta.id,
                                    title: tagTitle.text
                                };
                                if (meta.id === 0) {
                                    Cx.Network.post(urls.tagsUrl(), obj, (resp)=>{
                                                        try {
                                                            const res = JSON.parse(resp);
                                                            const body = res.body;
                                                            meta.id = body.id;
                                                            tagTitle.text = body.title;
                                                        } catch(e) {
                                                            console.log(e);
                                                        }
                                                        ok(meta.id,tagTitle.text);
                                                        mask.hideMask();
                                                    });
                                } else {
                                    Cx.Network.put(urls.tagsUrl(), obj, (resp)=>{
                                                        try {
                                                            const res = JSON.parse(resp);
                                                            const body = res.body;
                                                            meta.id = body.id;
                                                            tagTitle.text = body.title;
                                                        } catch(e) {
                                                            console.log(e);
                                                        }
                                                        ok(meta.id,tagTitle.text);
                                                        mask.hideMask();
                                                    });
                                }
                            }
                        }

                        App.Button {
                            text: qsTr("Remove")
                            onClicked: {
                                Cx.Network.del(urls.tagsUrl() + meta.id, (resp)=>{
                                                   try {
                                                       const res = JSON.parse(resp);
                                                       meta.id = 0;
                                                       tagTitle.text = "";
                                                       tagEdit.close();
                                                   } catch(e) {
                                                       console.log(e);
                                                   }
                                                   ok(meta.id,tagTitle.text);
                                                   mask.hideMask();
                                               });
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        App.Button {
                            text: qsTr("Close")
                            onClicked: {
                                tagEdit.close();
                            }
                        }
                    }
                }
                Grid {
                    anchors.centerIn: parent
                    columns: 2
                    columnSpacing: Cx.Theme.baseMargin
                    rowSpacing: Cx.Theme.baseMargin
                    Label { text: qsTr("Tag") }
                    TextField { id: tagTitle }
                }
            }
        }
    }

    Component {
        id: contentTagEditComponent

        App.Popup {
            id: popup

            signal ok(var tags)
            signal loaded()

            function setChecked(tags) {
                var existTags = tags.map((item)=>{return item.id; });
                for (var i = 0; i < tagsModel.count(); ++i) {
                    const item = tagsModel.get(i);
                    const idx = existTags.indexOf(item.id);
                    if (idx !== -1) {
                        tagsModel.set(i,"check",true);
                        existTags.splice(idx,1);
                    }
                }
            }

            header: App.ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    App.Button {
                        text: qsTr("Ok")
                        onClicked: {
                            const checkedTags = listView.checkedTags();
                            popup.ok(checkedTags);
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    App.Button {
                        text: qsTr("Close")
                        onClicked: {
                            popup.close();
                        }
                    }
                }
            }

            body: ListView {
                id: listView
                clip: true

                function checkedTags() {
                    var checked = [];
                    for (var i = 0; i < count; ++i) {
                        const obj = tagsModel.get(i);
                        if (obj.check === true) {
                            checked.push({id:obj.id, name: obj.name, title: obj.title });
                        }
                    }
                    return checked;
                }

                model: Cx.ListModel {
                    id: tagsModel
                    roleNames: ["id","title","check"]
                    Component.onCompleted: {
                        mask.showMask();
                        Cx.Network.get(urls.tagsUrl(), (resp)=>{
                                           try {
                                               const res = JSON.parse(resp);
                                               const body = res.body;

                                               for (var i in body) {
                                                   var tag = body[i];
                                                   tag["check"] = false;
                                                   tagsModel.append(tag);
                                               }
                                           } catch(e) {
                                               console.log(e);
                                           }
                                           popup.loaded();
                                           mask.hideMask();
                                       });
                    }
                }
                delegate: CheckBox {
                    checkState: model.check ? Qt.Checked : Qt.Unchecked
                    text: model.title
                    onCheckStateChanged: {
                        tagsModel.set(model.index,"check", (checkState === Qt.Checked ? true : false))
                    }
                }
            }
        }
    }

    App.Mask {
        id: mask
        anchors.fill: parent
    }

    App.HomePage {
        id: homePage
        anchors.fill: parent
    }
}
