 import QtQml.Models 2.15
import QtQuick 2.15
 import QtQuick.Window 2.15
import QtQuick.Controls 2.15
 import QtQuick.Layouts 1.15
// import QtQuick.LocalStorage 2.15
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

    function mouseClickMapToListViewIndex(mouseArea, listView, mouse) {
        const p = mouseArea.mapToItem(listView,mouse.x,mouse.y);
        const idx = listView.indexAt(p.x+listView.contentX, p.y+listView.contentY);
        return idx;
    }

    Settings {
        id: appSettings
        property bool contentLineWrap: true
        property int contentFontPointSize: app.font.pointSize
        property string host: "localhost"
        property int port: 80
        property string basicAuthKey: ""
        property string basicAuthValue: ""

        function basicAuth() {
            var auth = {
                "Authorization": basicAuthKey + ":" + basicAuthValue,
            };
            return auth;
        }
    }

    QtObject {
        id: status

        readonly property int stActive: 0 // 激活
        readonly property int stInActive: 1 // 未激活
        readonly property int stInValid: 2 // 失效
        readonly property int stTrash: 3 // 删除
    }

    QtObject {
        id: badges

        readonly property int rank: 0 // 置顶排序
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

        function postBadgesUrl() {
            return "https://<host>:<port>/api/badges/"
            .replace("<host>",appSettings.host)
            .replace("<port>", appSettings.port)
        }
    }

    Connections {
        target: Cx.Sys

        function onSystemTrayIconActivated(reason) {
            // double clicked
            if (reason === 2) {
                app.showWindow()
            }
        }
    }

//    Cx.GlobalShortcut {
//        sequence: "Shift+w"
//        onActivated: {
//            app.showWindow()
//        }
//    }

    App.MainPage {
        id: mainPage
        anchors.fill: parent
        visible: !homePage.visible

        background: Rectangle {
             color: "#e2e1e4" // 芡食白
        }

        header: ToolBar {
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Cx.Theme.baseMargin
                anchors.rightMargin: Cx.Theme.baseMargin
                anchors.bottomMargin: 2

                Button { action: actionBacktoHome }
                ToolSeparator {}
                Button { action: actionNew }
                Button { action: actionTags }
                Button { action: actionTrash }
                Item { Layout.fillWidth: true }
                Button { action: actionRefresh }
                ToolSeparator {}
                Button { action: actionSettings }
            }

            Rectangle {
                width: parent.width
                anchors.bottom: parent.bottom
                height:1
                color: Cx.Theme.bgDeepColor
            }
        }

        Action {
            id: actionNew
            text: qsTr('New')
            shortcut: StandardKey.New
            onTriggered: {
                var pp = contentComponent.createObject(mainPage);
                contentConnection.target = pp;
                 const tag = tagsView.model.get(tagsView.currentIndex);
                 if(tag !== undefined && tag.name !== "_all_") {
                     pp.setDefaultTag(tag);
                 }
                pp.open();
            }
        }

        Action {
            id: actionTags
            text: qsTr("Tags")
            onTriggered: {
                var pp = tagsComponent.createObject(mainPage);
                tagNewConnection.target = pp;
                pp.open();
            }
        }

        Action {
            id: actionTrash
            text: qsTr("Trash")
            onTriggered: {
                var pp = trashComponent.createObject(mainPage);
                contentConnection.target = pp;
                pp.open();
            }
        }

        Action {
            id: actionSettings
            text: qsTr("Settings")
            onTriggered: {
                var pp = settingsComponent.createObject(mainPage)
                pp.open();
            }
        }

        Action {
            id: actionRefresh
            text: qsTr("Refresh")
            onTriggered: {
                tagsView.update();
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
                tagsView.update();
            }
        }

        Cx.ListModel {
            id: contentsModel
            roleNames: ["id","title","created_at","updated_at","badges"]

            function hasBadge(index, badgeType) {
                const obj = contentsModel.get(index);
                const badges = obj.badges || [];
                for (var i in badges) {
                    const badge = badges[i];
                    if (badge.badge_name === badgeType && badge.badge_value !== null) {
                        return true;
                    }
                }
                return false;
            }

            function update(tags) {
                mask.showMask();

                var tagQuery = "?";
                if (tags !== undefined) {
                    for (var i in tags) {
                        tagQuery += ("tag=" + tags[i] + "&")
                    }
                }
                Cx.Network.get(urls.postsUrl() + tagQuery, appSettings.basicAuth(), (resp)=>{
                                   contentsModel.clear();
                                   try {
                                       const res = JSON.parse(resp);
                                       const body = res.body || [];
                                       for (var i in body) {
                                           var date = new Date(body[i].updated_at)
                                           body[i].updated_at = date.format("yyyy-MM-dd hh:mm:ss")
                                           contentsModel.append(body[i]);
                                       }
                                   } catch(e) {
                                       console.log(e,'; Response:',resp);
                                   }
                                   mask.hideMask();
                               });
            }
        }

            /*
        Cx.ListModel {
            id: tagsModel
            roleNames: ["id","title","created_at"]

            function update() {
                mask.showMask();
                Cx.Network.get(urls.tagsUrl(),appSettings.basicAuth(),(resp)=>{
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
                                       console.log(e,'; Response:',resp);
                                   }
                                   tagsView.currentIndex = oldIdx
                                   mask.hideMask();
                               });
            }
        }
        */

        SplitView {
            anchors.fill: parent
            orientation: Qt.Horizontal

            ListView {
                id: contentListView
                SplitView.fillWidth: true
                SplitView.fillHeight: true
                boundsBehavior: Flickable.DragOverBounds

                clip: true

                model: contentsModel

                delegate: App.LinkItem {
                    width: parent !== null ? parent.width : 0
                    height: 40

                    text: {
                        var str = '<a href="%1" style="color:black">%2</a>'.replace('%1',model.id)
                        str = str.replace('%2',model.title)
                        return '<small>%1 - </small>'.replace('%1',model.updated_at) + '<b>%1</b>'.replace('%1',str)
                    }

                    badges: model.badges

                    onLinkClicked: {
                        var pp = contentComponent.createObject(mainPage);
                        contentConnection.target = pp;
                        pp.edit(link);
                    }
                }

                MouseArea {
                    acceptedButtons: Qt.RightButton
                    anchors.fill: parent
                    onClicked: {
                        const idx = app.mouseClickMapToListViewIndex(this, contentListView, mouse);
                        contentListView.currentIndex = idx;
                        if (idx !== -1) {
                            pinAction.pinned = contentsModel.hasBadge(idx, badges.rank)
                            contentMenu.popup();
                            mouse.accepted = true;
                        }
                    }
                }

                Menu {
                    id: contentMenu
                    Action {
                        id: pinAction
                        text: pinned ? qsTr("Unpin") : qsTr("Pin")

                        property bool pinned: false

                        onTriggered: {
                            mask.showMask();

                            const curItem = contentsModel.get(contentListView.currentIndex);
                            if ((curItem.id || 0) === 0) {
                                return;
                            }

                            const data = {
                                post_id: curItem.id,
                                badge_name: badges.rank,
                                badge_value: "",
                            };

                            if (pinAction.pinned === true) {
                                Cx.Network.del2(urls.postBadgesUrl(), appSettings.basicAuth(), data, (resp)=>{
                                                    try {
                                                        contentConnection.onOk(0);
                                                    } catch(e) {
                                                        console.log(e);
                                                    }
                                                    mask.hideMask();
                                                })
                            } else {
                                Cx.Network.post(urls.postBadgesUrl(), appSettings.basicAuth(), data, (resp)=>{
                                                    try {
                                                        contentConnection.onOk(0);
                                                    } catch(e) {
                                                        console.log(e);
                                                    }
                                                    mask.hideMask();
                                                })
                            }
                        }
                    }

                    MenuSeparator {}

                    Action {
                        text: qsTr("Remove")
                    }
                }
            }

            Column {
                id: navi
                SplitView.preferredWidth: 150
                SplitView.maximumWidth: parent.width * 0.8
                 SplitView.minimumWidth: tagsView.contentWidth
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

                Rectangle {
                    color: "#e2e1e4" // 芡食白
                    width: parent.width
                    height: parent.height - 25

                    App.OneColumnTreeView {
                        id: tagsView
                        clip: true
                        anchors.fill: parent
                        currentIndex: 0
                        boundsBehavior: Flickable.DragOverBounds

                        onCurrentIndexChanged: {
                            if (tagsView.currentIndex === 0) {
                                contentsModel.update([]);
                            } else if (tagsView.currentIndex !== -1) {
                                const row = tagsView.model.get(tagsView.currentIndex);
                                console.log(JSON.stringify(row));
                                if (row !== undefined) {
                                    contentsModel.update([row.id]);
                                }
                            }
                        }

                        function update() {
                            mask.showMask();
                            Cx.Network.get(urls.tagsUrl(),appSettings.basicAuth(),(resp)=>{
                                               const oldIdx = tagsView.currentIndex
                                               tagsView.model.clear();
                                               try {
                                                   const res = JSON.parse(resp);
                                                   const body = res.body;
                                                   tagsView.load(body);
                                               } catch(e) {
                                                   console.log(e,'; Response:',resp);
                                               }
                                               tagsView.currentIndex = oldIdx
                                               mask.hideMask();
                                           });
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: {
                                const idx = app.mouseClickMapToListViewIndex(this, tagsView, mouse)
                                if (idx !== -1) {
                                    tagsView.currentIndex = idx;
                                    if (mouse.button & Qt.LeftButton) {
                                        var item = tagsView.currentItem;
                                        item.execClick(this.mapToItem(item, mouse.x, mouse.y))
                                    } else if (mouse.button & Qt.RightButton) {
                                        tagMenu.popup()
                                    }
                                }
                            }

                            Menu {
                                id: tagMenu

                                Action {
                                    text: qsTr("New")

                                    onTriggered: {
                                        const m = tagsView.model.get(tagsView.currentIndex);
                                        var tag = tagEditComponent.createObject(mainPage);
                                         tagNewConnection.target = tag;
                                        tag.edit({id:0,title:"",parent: m.id});
                                    }
                                }

                                Action {
                                    text: qsTr("Remove")
                                    onTriggered: {
                                        // Cx.Network.del()
                                    }
                                }
                            }
                        }
                    }
                }
            }
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
            }

            function edit(postID) {
                mask.showMask();
                Cx.Network.get(urls.postsUrl() + postID, appSettings.basicAuth(), (resp)=>{
                                   try {
                                       const res = JSON.parse(resp);
                                       const body = res.body;
                                       const tags = body.tags || [];
                                       meta.id = body.id;
                                       textArea.text = body.content;
                                       meta.changed = false;
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
                id: exitCon
                target: null

                function onAccept() {
                    actionSave.trigger();
                }

                function onReject() {
                    popup.close();
                }
            }

            Connections {
                id: contentTagEditorCon
                target: null

                function onOk(tags) {
                    tagRepeater.model.clear();
                    for(var i = 0; i < tags.length; ++i){
                        tagRepeater.model.append(tags[i]);
                    }
                    meta.changed = true;
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

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Cx.Theme.baseMargin
                    anchors.rightMargin: Cx.Theme.baseMargin

                    Button {
                        visible: popup.editable
                        action: actionSave
                    }

                    Button {
                        visible: popup.editable
                        text: qsTr("Edit tags")
                        onClicked: {
                            meta.tagEditor = contentTagEditComponent.createObject(popup.contentItem);
                            contentTagEditorCon.target = meta.tagEditor;
                        }
                    }

                    Button {
                        visible: popup.editable
                        text: qsTr("Remove")
                        onClicked: {
                            mask.showMask();
                            Cx.Network.del(urls.postsUrl() + meta.id, appSettings.basicAuth(), (resp)=>{
                                               meta.id = 0;
                                               popup.ok(0);
                                               popup.close();
                                               mask.hideMask();
                                               banner.show("Data removed !");
                                           });
                        }
                    }

                    Button {
                        visible: !popup.editable
                        text: qsTr("Recovery")
                        onClicked: {
                            mask.showMask();
                            Cx.Network.put(urls.postsUrl() + "status/" + meta.id + "?status=0", appSettings.basicAuth(), null, (resp)=>{
                                               meta.id = 0;
                                               popup.ok(0);
                                               popup.close();
                                               mask.hideMask();
                                           });
                        }
                    }

                    Button {
                        visible: !popup.editable
                        text: qsTr("Delete")
                        onClicked: {
                            mask.showMask();
                            Cx.Network.del(urls.postsUrl() + meta.id + "?del=1", appSettings.basicAuth(), (resp)=>{
                                               meta.id = 0;
                                               popup.ok(0);
                                               popup.close();
                                               mask.hideMask();
                                               banner.show("Data remove permanently !");
                                           });
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Button {
                        text: qsTr("Close")
                        onClicked: {
                            if (meta.changed) {
                                var pp = changeAlertComponent.createObject(popup.contentItem)
                                exitCon.target = pp;
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
                    Flow {
                        Layout.fillWidth: true
                        Layout.topMargin: Cx.Theme.baseMargin / 2
                        spacing: Cx.Theme.baseMargin
                        leftPadding: 8

                        Repeater {
                            id: tagRepeater
                            model: Cx.ListModel {
                                roleNames: ["id","title"]
                            }
                            delegate: Button {
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
                            leftPadding: Cx.Theme.baseMargin * 2
                            rightPadding: Cx.Theme.baseMargin * 2

                            Cx.SyntaxHighlighter {
                                target: textArea.textDocument
                            }

                            onTextChanged: {
                                meta.changed = true
                            }
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
                        Cx.Network.post(urls.postsUrl(), appSettings.basicAuth(), obj,(resp)=>{
                                            try {
                                                const res = JSON.parse(resp);
                                                const body = res.body;
                                                meta.id = body.id;
                                                textArea.text = body.content;
                                                meta.changed = false;
                                            } catch(e) {
                                                console.log(e);
                                            }
                                            popup.ok(meta.id)
                                            mask.hideMask();
                                            banner.show('Data saved .')
                                        });
                    } else {
                        Cx.Network.put(urls.postsUrl(), appSettings.basicAuth(), obj,(resp)=>{
                                           try {
                                               const res = JSON.parse(resp);
                                               const body = res.body;
                                               meta.id = body.id;
                                               meta.changed = false;
                                           } catch(e) {
                                               console.log(e);
                                           }
                                           popup.ok(meta.id)
                                           mask.hideMask();
                                           banner.show('Data saved .')
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

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    Button {
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

                    Button {
                        text: qsTr("Close")
                        onClicked: popup.close()
                    }
                }
            }

            body: ListView {
                id: tagList
                clip: true
                boundsBehavior: Flickable.DragOverBounds

                model: Cx.ListModel {
                    id: tagModel
                    roleNames: ["id","title","created_at"]
                    Component.onCompleted: {
                        update();
                    }

                    function update() {
                        mask.showMask();
                        Cx.Network.get(urls.tagsUrl(), appSettings.basicAuth(), (resp)=>{
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

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Cx.Theme.baseMargin
                    anchors.rightMargin: Cx.Theme.baseMargin

                    Item {
                        Layout.fillWidth: true
                    }

                    Button {
                        text: qsTr("Close")
                        onClicked: popup.close()
                    }
                }
            }

            body: ListView {
                id: trashView
                clip: true
                boundsBehavior: Flickable.DragOverBounds

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
                        Cx.Network.get(urls.postsUrl() + tagQuery + "status=" + status.stTrash, appSettings.basicAuth(), (resp)=>{
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
                    height: Cx.Theme.contentHeight

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: Cx.Theme.baseMargin * 2
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

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Cx.Theme.baseMargin
                    anchors.rightMargin: Cx.Theme.baseMargin

                    Button {
                        text: qsTr("Save")
                        onClicked: {}
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Button {
                        text: qsTr("Cancel")
                        onClicked: popup.close()
                    }
                }
            }

            body: Item {
                implicitWidth: 100
                implicitHeight: 100
                GridLayout {
                    anchors.fill: parent
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

                    Label {
                        text: qsTr("Auth key")
                        Layout.margins: Cx.Theme.baseMargin
                    }

                    TextField {
                        onEditingFinished: {
                            appSettings.basicAuthKey = text.trim();
                        }
                        Component.onCompleted: {
                            text = appSettings.basicAuthKey;
                        }
                    }

                    Label {
                        text: qsTr("Auth value")
                        Layout.margins: Cx.Theme.baseMargin
                    }

                    TextField {
                        onEditingFinished: {
                            appSettings.basicAuthValue = text.trim();
                        }
                        Component.onCompleted: {
                            text = appSettings.basicAuthValue;
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.columnSpan: 2
                    }
                }
            }
        }
    }

    Component {
        id: tagEditComponent

        App.Popup {
            id: popup
            implicitWidth: 300
            implicitHeight: 200

            signal ok(int tagID, string tagTitle);

            property int tagID: 0
            property string tagTitle: ""
            property int parentID: -1

            function edit(row) {
                tagID = row.id || 0;
                tagTitle = row.title;
                parentID = (row.parent||0) === 0 ? -1 : row.parent

                tagTitleField.text = row.title;

                open();
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

                            const obj = {
                                id: popup.tagID,
                                title: tagTitleField.text,
                                parent: popup.parentID
                            };

                            if (popup.tagID === 0) {
                                Cx.Network.post(urls.tagsUrl(), appSettings.basicAuth(), obj, (resp)=>{
                                                    try {
                                                        const res = JSON.parse(resp);
                                                        const body = res.body;
                                                        popup.tagID = body.id;
                                                        tagTitleField.text = body.title;
                                                    } catch(e) {
                                                        console.log(e);
                                                    }
                                                    ok(popup.tagID,tagTitleField.text);
                                                    mask.hideMask();
                                                });
                            } else {
                                Cx.Network.put(urls.tagsUrl(), appSettings.basicAuth(), obj, (resp)=>{
                                                    try {
                                                        const res = JSON.parse(resp);
                                                        const body = res.body;
                                                       popup.tagID = body.id;
                                                        tagTitleField.text = body.title;
                                                    } catch(e) {
                                                        console.log(e);
                                                    }
                                                   ok(popup.tagID,tagTitleField.text);
                                                    mask.hideMask();
                                                });
                            }
                        }
                    }

                    Button {
                        text: qsTr("Remove")
                        onClicked: {
                            Cx.Network.del(urls.tagsUrl() + meta.id, appSettings.basicAuth(), (resp)=>{
                                               popup.tagID = 0;
                                               tagTitleField.text = "";
                                               popup.close();
                                               ok(popup.tagID,tagTitleField.text);
                                               mask.hideMask();
                                           });
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
                implicitWidth: 100
                implicitHeight: 100
                Row {
                    anchors.centerIn: parent
                    spacing: Cx.Theme.baseMargin
                    Label { text: qsTr("Tag") }
                    TextField { id: tagTitleField }
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

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: Cx.Theme.baseMargin
                    anchors.rightMargin: Cx.Theme.baseMargin

                    Button {
                        text: qsTr("Ok")
                        onClicked: {
                            const checkedTags = listView.checkedTags();
                            popup.ok(checkedTags);
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
                        Cx.Network.get(urls.tagsUrl(), appSettings.basicAuth(), (resp)=>{
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

    Component {
        id: changeAlertComponent

        App.Popup {
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

    App.Banner {
        id: banner
        x: visible ? app.width - implicitWidth - 4 : app.width + 4
        y: app.height - implicitHeight - 4
    }

    App.Mask {
        id: mask
        anchors.fill: parent
        maskItem: mainPage
    }

    App.HomePage {
        id: homePage
        anchors.fill: parent
        onLogin: {
            contentsModel.update([]);
            tagsView.update();
            homePage.visible = false
        }
    }

}
