import QtQml.Models 2.15
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
// import QtQuick.LocalStorage 2.15
import Qt.labs.settings 1.1

import CxQuick 0.1
import CxQuick.Controls 0.1 as Cx
import CxQuick.App 0.1 as CxApp
import "qml/AppConfigs.js" as AppConfig

ApplicationWindow {
    id: app
    width: 1000
    height: 720
    visible: true
    title: qsTr("Writer")

    QtObject {
        id: uiConf
        readonly property int naviSize: 300
        readonly property string datetimeFormat: "yyyy年MM月dd日 hh:mm:ss"
    }

    Component.onCompleted: {
        CxNetwork.enableHttps(true);
    }

    function showWindow() {
        app.showNormal()
        app.raise()
        app.requestActivate()
    }

    Connections {
        target: CxApp.Sys

        function onSystemNotify(reason) {
            // double clicked & global shortcut & active by run
            if (reason === 2 || reason === 5 || reason === 6) {
                app.showWindow()
            }
        }
    }

    Cx.MainPage {
        id: mainPage
        anchors.fill: parent
        visible: !homePage.visible

        background: Rectangle {
             color: "#e2e1e4" // 芡食白
        }

        header: ToolBar {
            upRadius: 0
            bottomRadius: 0
            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: CxTheme.baseMargin
                anchors.rightMargin: CxTheme.baseMargin
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
                color: CxTheme.bgDeepColor
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
                const idx = tagsView.currentIndex;
                tagsView.update();
                if (idx === 0) {
                    contentsModel.update();
                }
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
                // tagsView.update();
                contentsModel.update();
            }
        }

        Connections {
            id: tagNewConnection
            target: null

            function onOk(tagID, tagTitle) {
                tagsView.update();
            }
        }

        CxListModel {
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
                var tagQuery = "";
                if (tags !== undefined) {
                    for (var i in tags) {
                        tagQuery += ("tag=" + tags[i] + "&")
                    }
                } else {
                    // get current tag index.
                    const tagID = tagsView.model.get(tagsView.currentIndex).id;
                    if (tagID > 0) {
                        tagQuery = "tag=" + tagID;
                    }
                }
                CxNetwork.get(URLs.url("posts/", tagQuery), AppConfig.basicAuth(), (resp)=>{
                                   contentsModel.clear();
                                   try {
                                       const res = JSON.parse(resp);
                                       const body = res.body || [];
                                       for (var i in body) {
                                           var date = new Date(body[i].updated_at)
                                           body[i].updated_at = date.format(uiConf.datetimeFormat)
                                           contentsModel.append(body[i]);
                                       }
                                   } catch(e) {
                                       console.log(e,'; Response:',resp);
                                   }
                                   mask.hideMask();
                               });
            }
        }

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

                delegate: LinkItem {
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
                        const idx = CxFw.mouseClickMapToListViewIndex(this, contentListView, mouse);
                        contentListView.currentIndex = idx;
                        if (idx !== -1) {
                            pinAction.pinned = contentsModel.hasBadge(idx, AppConfig.badges.Rank)
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
                                badge_name: AppConfig.badges.Rank,
                                badge_value: "",
                            };

                            if (pinAction.pinned === true) {
                                // urls.postBadgesUrl()
                                CxNetwork.del2(URLs.url("badges/"), AppConfig.basicAuth(), data, (resp)=>{
                                                    try {
                                                        contentConnection.onOk(0);
                                                    } catch(e) {
                                                        console.log(e);
                                                    }
                                                    mask.hideMask();
                                                })
                            } else {
                                // urls.postBadgesUrl()
                                CxNetwork.post(URLs.url("badges/"), AppConfig.basicAuth(), data, (resp)=>{
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
                SplitView.preferredWidth: CxSettings.get(AppConfig.settings.naviSizeName) === undefined ? AppConfig.settings.naviSize : CxSettings.get(AppConfig.settings.naviSizeName)
                SplitView.maximumWidth: parent.width * 0.8
                SplitView.minimumWidth: tagsView.contentWidth
                SplitView.fillHeight: true

                Component.onDestruction: {
                    CxSettings.set(AppConfig.settings.naviSizeName, navi.SplitView.preferredWidth)
                }

                Rectangle {
                    color: BoxTheme.backgroundInActive
                    width: parent.width
                    height: parent.height

                    OneColumnTreeView {
                        id: tagsView
                        clip: true
                        anchors.fill: parent
                        boundsBehavior: Flickable.DragOverBounds
                        currentIndex: (CxSettings.get(AppConfig.settings.defaultNavi) || -1)

                        onCurrentIndexChanged: {
                            if (tagsView.currentIndex !== -1 && tagsView.model.count() > currentIndex) {
                                contentsModel.update();
                            } else {
                                contentsModel.clear();
                            }
                        }

                        Component.onDestruction: saveState()

                        function saveState() {
                            const c = tagsView.model.count();
                            CxSettings.beginWriteArray(AppConfig.settings.naviExpandArray);
                            for (var i = 0; i < c; ++i) {
                                const item = tagsView.model.get(i);
                                CxSettings.setArrayIndex(i);
                                CxSettings.set(AppConfig.settings.naviItemExpand,item.expand);
                            }
                            CxSettings.endArray();
                            CxSettings.set(AppConfig.settings.defaultNavi, tagsView.currentIndex)
                        }

                        function update() {
                            mask.showMask();
                            saveState();
                            // urls.tagsUrl()
                            CxNetwork.get(URLs.url("tags/"), AppConfig.basicAuth(), (resp)=>{
                                               try {
                                                   const oldIdx = tagsView.currentIndex;

                                                   const res = JSON.parse(resp);
                                                   const body = res.body;
                                                   tagsView.load(body);

                                                  CxSettings.beginReadArray(AppConfig.settings.naviExpandArray);
                                                  const c = tagsView.model.count();
                                                  for (var i = 0; i < c; ++i) {
                                                      CxSettings.setArrayIndex(i);
                                                      const expand = CxSettings.get(AppConfig.settings.naviItemExpand) === "true" ? true : false;
                                                      tagsView.expandIndex(i, expand);
                                                  }
                                                  CxSettings.endArray();

                                                  if (oldIdx === -1) {
                                                    tagsView.currentIndex = 0;
                                                  } else {
                                                      tagsView.currentIndex = oldIdx
                                                  }
                                               } catch(e) {
                                                   console.log(e,'; Response:',resp);
                                               }
                                               mask.hideMask();
                                           });
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: {
                                const idx = CxFw.mouseClickMapToListViewIndex(this, tagsView, mouse);
                                if (idx !== - 1) {
                                    if (mouse.button & Qt.LeftButton) {
                                        var item = tagsView.itemAtIndex(idx);
                                        if(!item.execClick(this.mapToItem(item, mouse.x, mouse.y))) {
                                            tagsView.currentIndex = idx;
                                        }
                                    } else if (mouse.button & Qt.RightButton) {
                                        tagsView.currentIndex = idx;
                                        tagMenu.popup()
                                    }
                                } else {
                                    // tagsView.currentIndex = -1;
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
                                        tag.edit({id:0, title:"", parent: m.id});
                                    }
                                }

                                Action {
                                    text: qsTr("Edit")
                                    onTriggered: {
                                        const m = tagsView.model.get(tagsView.currentIndex);
                                        console.log('Edit tag:',JSON.stringify(m));
                                        var tag = tagEditComponent.createObject(mainPage);
                                         tagNewConnection.target = tag;
                                        tag.edit({id: m.id, title: m.title, parent: m.parent});
                                    }
                                }

                                Action {
                                    text: qsTr("Remove")
                                    onTriggered: {
                                        mask.showMask();
                                        const m = tagsView.model.get(tagsView.currentIndex);
                                        // urls.tagsUrl() + m.id
                                        CxNetwork.del(URLs.url("tags/"+m.id), AppConfig.basicAuth(), (resp)=>{
                                                           try {
                                                               tagsView.update();
                                                           } catch(e) {
                                                               console.log('[ERROR] Remove tag:'+JSON.stringify(e));
                                                           }
                                                           mask.hideMask();
                                                       })
                                    }
                                }

                                MenuSeparator {}

                                Action {
                                    text: qsTr("Top")
                                }
                                Action {
                                    text: qsTr("Up")
                                }
                                Action {
                                    text: qsTr("Down")
                                }
                                Action {
                                    text: qsTr("Bottom")
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

        Cx.Popup {
            id: popup

            signal ok(int id)
            property int postID: 0
            property bool editable: true
            property bool changed: false
            property Cx.Popup tagEditor: null

            closePolicy: Popup.NoAutoClose
            implicitWidth: {
                var dw = parent.width * 0.8;
                if (dw > 800) { dw = 800; }
                return dw;
            }
            implicitHeight: parent.height * 0.95

            function edit(postID) {
                mask.showMask();
                // urls.postsUrl() + postID
                CxNetwork.get(URLs.url("posts/"+postID), AppConfig.basicAuth(), (resp)=>{
                                   try {
                                       const res = JSON.parse(resp);
                                       const body = res.body;
                                       const tags = body.tags || [];
                                       popup.postID = body.id;
                                       const date = new Date(body.created_at)
                                       createdAtField.text = qsTr("Created at: ") + date.format(uiConf.datetimeFormat)
                                       textArea.text = body.content;
                                       popup.changed = false;
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
                    popup.changed = true;
                }

                function onLoaded() {
                    var tags = [];
                    for (var i = 0; i < tagRepeater.model.count(); ++i) {
                        tags.push(tagRepeater.model.get(i));
                    }
                    popup.tagEditor.setChecked(tags);
                    popup.tagEditor.visible = true;
                }
            }

            function setDefaultTag(tag) {
                tagRepeater.model.append(tag)
            }

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: CxTheme.baseMargin
                    anchors.rightMargin: CxTheme.baseMargin

                    Button {
                        visible: popup.editable
                        action: actionSave
                    }

                    Button {
                        visible: popup.editable
                        text: qsTr("Edit tags")
                        onClicked: {
                            popup.tagEditor = contentTagEditComponent.createObject(popup.contentItem);
                            contentTagEditorCon.target = popup.tagEditor;
                        }
                    }

                    Button {
                        visible: popup.editable
                        text: qsTr("Remove")
                        onClicked: {
                            mask.showMask();
                            // urls.postsUrl() + popup.postID
                            CxNetwork.del(URLs.url("posts/"+popup.postID), AppConfig.basicAuth(), (resp)=>{
                                               popup.postID = 0;
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
                            // urls.postsUrl() + "status/" + popup.postID + "?status=0"
                            CxNetwork.put(URLs.url("posts/status/"+popup.postID, "status=0"), AppConfig.basicAuth(), null, (resp)=>{
                                               post.postID = 0;
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
                            // urls.postsUrl() + popup.postID + "?del=1"
                            CxNetwork.del(URLs.url("posts/"+popup.postID,"del=1"), AppConfig.basicAuth(), (resp)=>{
                                               popup.postID = 0;
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
                            if (popup.changed) {
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
                        Layout.topMargin: BoxTheme.topPadding
                        spacing: 0
                        leftPadding: BoxTheme.leftPadding

                        Repeater {
                            id: tagRepeater
                            model: CxListModel {
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
                        color: CxTheme.bgDeepColor
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        TextArea {
                            id: textArea
                            readOnly: !popup.editable
                            tabStopDistance: 40
                            wrapMode: CxSettings.get(AppConfig.settings.contentLineWrap) === "true" ? TextArea.WrapAnywhere : TextArea.NoWrap
                            selectByMouse: true
                            font.pointSize: CxSettings.get(AppConfig.settings.contentFontPointSize)
                            leftPadding: CxTheme.baseMargin * 2
                            rightPadding: CxTheme.baseMargin * 2

                            CxSyntaxHighlighter {
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
                padding: CxTheme.baseMargin
                horizontalAlignment: Qt.AlignRight
            }

            Action {
                id: actionSave
                text: qsTr("Save")
                // shortcut: StandardKey.Save
                onTriggered: {
                    if (textArea.text.trim() === '') { return; }
                    var obj = {
                        "id": popup.postID,
                        "title": CxFw.getFirstLine(textArea.text),
                        "content": textArea.text,
                        "tags": [],
                    };

                    for (var i = 0; i < tagRepeater.model.count(); ++i) {
                        obj.tags.push(tagRepeater.model.get(i).id);
                    }

                    mask.showMask();
                    if (popup.postID <= 0) {
                        // urls.postsUrl()
                        CxNetwork.post(URLs.url("posts/"), AppConfig.basicAuth(), obj,(resp)=>{
                                            try {
                                                const res = JSON.parse(resp);
                                                const body = res.body;
                                                popup.postID = body.id;
                                                textArea.text = body.content;
                                                popup.changed = false;
                                            } catch(e) {
                                                console.log(e);
                                            }
                                            popup.ok(popup.id)
                                            mask.hideMask();
                                            banner.show('Data saved .')
                                        });
                    } else {
                        // urls.postsUrl()
                        CxNetwork.put(URLs.url("posts/"), AppConfig.basicAuth(), obj,(resp)=>{
                                           try {
                                               const res = JSON.parse(resp);
                                               const body = res.body;
                                               popup.postID = body.id;
                                               popup.changed = false;
                                           } catch(e) {
                                               console.log(e);
                                           }
                                           popup.ok(popup.postID)
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

        Cx.Popup {
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

                model: CxListModel {
                    id: tagModel
                    roleNames: ["id","title","created_at"]
                    Component.onCompleted: {
                        update();
                    }

                    function update() {
                        mask.showMask();
                        // urls.tagsUrl()
                        CxNetwork.get(URLs.url("tags/"), AppConfig.basicAuth(), (resp)=>{
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
                        color: CxTheme.bgNormalColor
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

        Cx.Popup {
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
                    anchors.leftMargin: CxTheme.baseMargin
                    anchors.rightMargin: CxTheme.baseMargin

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

                model: CxListModel {
                    id: trashModel
                    roleNames: ["id","title","created_at","updated_at"]

                    Component.onCompleted: {
                        update([]);
                    }

                    function update(tags) {

                        mask.showMask();
                        var tagQuery = "";
                        if (tags !== undefined) {
                            for (var i in tags) {
                                tagQuery += ("tag=" + tags[i] + "&")
                            }
                        }
                        // urls.postsUrl() + tagQuery + "status=" + status.stTrash
                        CxNetwork.get(URLs.url("posts/", tagQuery + "status=" + AppConfig.status.Trash), AppConfig.basicAuth(), (resp)=>{
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
                    height: CxTheme.contentHeight

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: CxTheme.baseMargin * 2
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
                        width: parent.width - CxTheme.baseMargin * 2
                        height: 1
                        x: CxTheme.baseMargin
                        color: CxTheme.bgNormalColor
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

        Cx.Popup {
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
                    anchors.leftMargin: CxTheme.baseMargin
                    anchors.rightMargin: CxTheme.baseMargin

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
                    columnSpacing: CxTheme.baseMargin
                    rowSpacing: CxTheme.baseMargin

                    Label {
                        Layout.fillWidth: true
                        Layout.margins: CxTheme.baseMargin
                        Layout.columnSpan: 2
                        // horizontalAlignment: Qt.AlignHCenter
                        text: qsTr("Content Editor")
                        font.pointSize: app.font.pointSize + 4
                        font.bold: true
                    }

                    CheckBox {
                        Layout.columnSpan: 2
                        Layout.margins: CxTheme.baseMargin
                        text: qsTr("Line Wrap")
                        onCheckStateChanged: {
                            CxSettings.set(AppConfig.settings.contentLineWrap, (checkState === Qt.Checked));
                        }
                        Component.onCompleted: {
                            checkState = CxSettings.get(AppConfig.settings.contentLineWrap) === "true" ? Qt.Checked : Qt.Unchecked;
                        }
                    }

                    Label {
                        text: qsTr("Font Point Size")
                        Layout.margins: CxTheme.baseMargin
                    }

                    ComboBox {
                        model: [9,10,11,12,13,14]
                        currentIndex: 0
                        onCurrentIndexChanged: {
                             CxSettings.set(AppConfig.settings.contentFontPointSize, parseInt(textAt(currentIndex)))
                        }

                        Component.onCompleted: {
                            const curVal = CxSettings.get(AppConfig.settings.contentFontPointSize)
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
                        Layout.margins: CxTheme.baseMargin
                        Layout.columnSpan: 2
                        // horizontalAlignment: Qt.AlignHCenter
                        text: qsTr("Server")
                        font.pointSize: app.font.pointSize + 4
                        font.bold: true
                    }

                    Label {
                        text: qsTr("Host")
                        Layout.margins: CxTheme.baseMargin
                    }

                    TextField {
                        onEditingFinished: {
                            CxSettings.set(AppConfig.settings.host,text.trim());
                        }
                        Component.onCompleted: {
                            text = CxSettings.get(AppConfig.settings.host);
                        }
                    }

                    Label {
                        text: qsTr("Port")
                        Layout.margins: CxTheme.baseMargin
                    }

                    TextField {
                        onEditingFinished: {
                            CxSettings.set(AppConfig.settings.port, parseInt(text.trim()));
                        }
                        Component.onCompleted: {
                            text = CxSettings.get(AppConfig.settings.port);
                        }
                    }

                    Label {
                        text: qsTr("Auth key")
                        Layout.margins: CxTheme.baseMargin
                    }

                    TextField {
                        onEditingFinished: {
                            CxSettings.set(AppConfig.settings.basicAuthKey, text.trim());
                        }
                        Component.onCompleted: {
                            text = CxSettings.get(AppConfig.settings.basicAuthKey);
                        }
                    }

                    Label {
                        text: qsTr("Auth value")
                        Layout.margins: CxTheme.baseMargin
                    }

                    TextField {
                        onEditingFinished: {
                            CxSettings.set(AppConfig.settings.basicAuthValue, text.trim());
                        }
                        Component.onCompleted: {
                            text = CxSettings.get(AppConfig.settings.basicAuthValue);
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

        Cx.Popup {
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
                    anchors.leftMargin: CxTheme.baseMargin
                    anchors.rightMargin: CxTheme.baseMargin

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
                                // urls.tagsUrl()
                                CxNetwork.post(URLs.url("tags/"), AppConfig.basicAuth(), obj, (resp)=>{
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
                                // urls.tagsUrl()
                                CxNetwork.put(URLs.url("tags/"), AppConfig.basicAuth(), obj, (resp)=>{
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
                            // urls.tagsUrl() + popup.tagID
                            CxNetwork.del(URLs.url("tags/"+popup.tagID), AppConfig.basicAuth(), (resp)=>{
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
                    spacing: CxTheme.baseMargin
                    Label { text: qsTr("Tag") }
                    TextField { id: tagTitleField }
                }
            }
        }
    }

    Component {
        id: contentTagEditComponent

        Cx.Popup {
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
                    anchors.leftMargin: CxTheme.baseMargin
                    anchors.rightMargin: CxTheme.baseMargin

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

                model: CxListModel {
                    id: tagsModel
                    roleNames: ["id","title","check"]
                    Component.onCompleted: {
                        mask.showMask();
                        // urls.tagsUrl()
                        CxNetwork.get(URLs.url("tags/"), AppConfig.basicAuth(), (resp)=>{
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
                        tagsModel.set(model.index, "check", (checkState === Qt.Checked ? true : false))
                    }
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
                    anchors.leftMargin: CxTheme.baseMargin
                    anchors.rightMargin: CxTheme.baseMargin

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

    Mask {
        id: mask
        anchors.fill: parent
        maskItem: mainPage
    }

    Cx.HomePage {
        id: homePage
        anchors.fill: parent
        onLogin: {
            tagsView.update();
            homePage.visible = false
        }
    }

}
