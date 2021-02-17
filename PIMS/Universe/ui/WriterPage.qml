import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Qt.labs.settings 1.1

import Universe 0.1
import "../qml" as Universe
import "../qml/AppConfigs.js" as AppConfig
import "../qml/BoxTheme.js" as BoxTheme
import "../qml/CxFw.js" as CxFw

Pane {
    id: app
    padding: 0
    background: Rectangle { color: "white" }

    QtObject {
        id: uiConf
        readonly property int naviSize: 300
        readonly property string datetimeFormat: "yyyy年MM月dd日 hh:mm:ss"
    }

    Component.onCompleted: {
        actionRefresh.trigger();
    }

        Universe.MainPage {
            id: mainPage
            anchors.fill: parent

//            background: Rectangle {
//                 color: "#e2e1e4" // 芡食白
//            }

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: BoxTheme.leftMargin
                    anchors.rightMargin: BoxTheme.rightMargin
                    anchors.bottomMargin: 2

                    Universe.Button { action: actionNew }
                    Universe.Button { action: actionTags }
                    Universe.Button { action: actionTrash }
                    Item { Layout.fillWidth: true }
                    Universe.Button { action: actionRefresh }
                }

                Rectangle {
                    width: parent.width
                    anchors.bottom: parent.bottom
                    height:1
                    color: BoxTheme.backgroundDeep
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
                        tagQuery = "tag=" + tagID;
                    }
                    CxNetwork.get(URLs.service("writer").url("posts/", tagQuery), AppConfig.basicAuth(), (resp)=>{
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
                Column {
                    id: navi
                    SplitView.preferredWidth: CxSettings.get(AppConfig.settings.naviSizeName) === undefined ? AppConfig.settings.naviSize : CxSettings.get(AppConfig.settings.naviSizeName)
                    SplitView.maximumWidth: parent.width * 0.8
                    SplitView.minimumWidth: 200
                    SplitView.fillHeight: true

                    Component.onDestruction: {
                        CxSettings.set(AppConfig.settings.naviSizeName, navi.SplitView.preferredWidth)
                    }

                    Rectangle {
                        width: parent.width
                        height: parent.height

                        Universe.OneColumnTreeView {
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
                                // URLs.service("writer").tagsUrl()
                                CxNetwork.get(URLs.service("writer").url("tags/"), AppConfig.basicAuth(), (resp)=>{
                                                  try {
                                                      const oldIdx = tagsView.currentIndex;

                                                      const res = JSON.parse(resp);
                                                      const body = res.body;
                                                      var tmp = [
                                                          {id: -1, title: "所有", created_at: "", parent: 0, expand: false, visible: true, level: 0, hasChildren: false },
                                                          {id: -2, title: "未分类", created_at: "", parent: 0, expand: false, visible: true, level: 0, hasChildren: false }
                                                      ];
                                                      tagsView.load(tmp.concat(body));

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
                                            // URLs.service("writer").tagsUrl() + m.id
                                            CxNetwork.del(URLs.service("writer").url("tags/"+m.id), AppConfig.basicAuth(), (resp)=>{
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

                ScrollView {
                    SplitView.fillWidth: true
                    SplitView.fillHeight: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    SplitView.minimumWidth: 300

                    ListView {
                        id: contentListView
                        width: parent.width
                        boundsBehavior: Flickable.DragOverBounds
                        clip: true
                        model: contentsModel

                        delegate: Universe.LinkItem {
                            width: parent !== null ? parent.width - BoxTheme.rightPadding : 0

                            text: '<a href="%1" style="color:black">%2</a>'.replace('%1',model.id).replace('%2',model.title)
                            dateTime: '<small>%1</small>'.replace('%1',model.updated_at)

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
                                        // URLs.service("writer").postBadgesUrl()
                                        CxNetwork.del2(URLs.service("writer").url("badges/"), AppConfig.basicAuth(), data, (resp)=>{
                                                            try {
                                                                contentConnection.onOk(0);
                                                            } catch(e) {
                                                                console.log(e);
                                                            }
                                                            mask.hideMask();
                                                        })
                                    } else {
                                        // URLs.service("writer").postBadgesUrl()
                                        CxNetwork.post(URLs.service("writer").url("badges/"), AppConfig.basicAuth(), data, (resp)=>{
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
                }
            }
        }

        Component {
            id: contentComponent

            Universe.Popup {
                id: popup

                signal ok(int id)
                property int postID: 0
                property bool editable: true
                property bool changed: false
                property Universe.Popup tagEditor: null

                closePolicy: Popup.NoAutoClose
                implicitWidth: {
                    var dw = parent.width * 0.8;
                    if (dw > 800) { dw = 800; }
                    return dw;
                }
                implicitHeight: parent.height * 0.95

                function edit(postID) {
                    mask.showMask();
                    // URLs.service("writer").postsUrl() + postID
                    CxNetwork.get(URLs.service("writer").url("posts/"+postID), AppConfig.basicAuth(), (resp)=>{
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
                        anchors.leftMargin: BoxTheme.leftMargin
                        anchors.rightMargin: BoxTheme.rightMargin

                        Universe.Button {
                            visible: popup.editable
                            action: actionSave
                        }

                        Universe.Button {
                            visible: popup.editable
                            text: qsTr("Edit tags")
                            onClicked: {
                                popup.tagEditor = contentTagEditComponent.createObject(popup.contentItem);
                                contentTagEditorCon.target = popup.tagEditor;
                            }
                        }

                        Universe.Button {
                            visible: popup.editable
                            text: qsTr("Remove")
                            onClicked: {
                                mask.showMask();
                                // URLs.service("writer").postsUrl() + popup.postID
                                CxNetwork.del(URLs.service("writer").url("posts/"+popup.postID), AppConfig.basicAuth(), (resp)=>{
                                                   popup.postID = 0;
                                                   popup.ok(0);
                                                   popup.close();
                                                   mask.hideMask();
                                                   banner.show("Data removed !");
                                               });
                            }
                        }

                        Universe.Button {
                            visible: !popup.editable
                            text: qsTr("Recovery")
                            onClicked: {
                                mask.showMask();
                                // URLs.service("writer").postsUrl() + "status/" + popup.postID + "?status=0"
                                CxNetwork.put(URLs.service("writer").url("posts/status/"+popup.postID, "status=0"), AppConfig.basicAuth(), null, (resp)=>{
                                                   post.postID = 0;
                                                   popup.ok(0);
                                                   popup.close();
                                                   mask.hideMask();
                                               });
                            }
                        }

                        Universe.Button {
                            visible: !popup.editable
                            text: qsTr("Delete")
                            onClicked: {
                                mask.showMask();
                                // URLs.service("writer").postsUrl() + popup.postID + "?del=1"
                                CxNetwork.del(URLs.service("writer").url("posts/"+popup.postID,"del=1"), AppConfig.basicAuth(), (resp)=>{
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

                        Universe.Button {
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
                                delegate: Universe.Button {
                                    text: model.title
                                }
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: BoxTheme.backgroundDeep
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
                                leftPadding: BoxTheme.leftPadding * 2
                                rightPadding: BoxTheme.rightPadding * 2

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
                    padding: BoxTheme.padding
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
                            const tagID = tagRepeater.model.get(i).id;
                            obj.tags.push(tagID > 0 ? tagID : 0);
                        }

                        mask.showMask();
                        if (popup.postID <= 0) {
                            // URLs.service("writer").postsUrl()
                            CxNetwork.post(URLs.service("writer").url("posts/"), AppConfig.basicAuth(), obj,(resp)=>{
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
                            // URLs.service("writer").postsUrl()
                            CxNetwork.put(URLs.service("writer").url("posts/"), AppConfig.basicAuth(), obj,(resp)=>{
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

            Universe.Popup {
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

                        Universe.Button {
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

                        Universe.Button {
                            text: qsTr("Close")
                            onClicked: popup.close()
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

                body: ScrollView {
                    anchors.fill: parent.contentItem
                    Flow {
                        width: popup.width
                        id: tags
                        padding: BoxTheme.padding

                        Repeater {
                            anchors.fill: parent
                            model: CxListModel {
                                id: tagModel
                                roleNames: ["id","title","created_at"]
                                Component.onCompleted: {
                                    update();
                                }

                                function update() {
                                    mask.showMask();
                                    // URLs.service("writer").tagsUrl()
                                    CxNetwork.get(URLs.service("writer").url("tags/"), AppConfig.basicAuth(), (resp)=>{
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

                            delegate: Universe.Button {
                                text: model.title
                                onClicked: {
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

                            /*
                            Item {
                                width: tag.contentWidth + tag.anchors.leftMargin + tag.anchors.rightMargin
                                height: 25

                                Text {
                                    id: tag
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
                            }
                            */
                        }
                    }
                }
            }
        }

        Component {
            id: trashComponent

            Universe.Popup {
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
                        anchors.leftMargin: BoxTheme.leftMargin
                        anchors.rightMargin: BoxTheme.rightMargin

                        Item {
                            Layout.fillWidth: true
                        }

                        Universe.Button {
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
                            // URLs.service("writer").postsUrl() + tagQuery + "status=" + status.stTrash
                            CxNetwork.get(URLs.service("writer").url("posts/", tagQuery + "status=" + AppConfig.status.Trash), AppConfig.basicAuth(), (resp)=>{
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
                        height: BoxTheme.contentHeight

                        Text {
                            anchors.fill: parent
                            anchors.leftMargin: BoxTheme.leftMargin * 2
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
                            width: parent.width - BoxTheme.margins * 2
                            height: 1
                            x: BoxTheme.margins
                            color: BoxTheme.backgroundNormal
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
            id: tagEditComponent

            Universe.Popup {
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
                        anchors.leftMargin: BoxTheme.leftMargin
                        anchors.rightMargin: BoxTheme.rightMargin

                        Universe.Button {
                            text: qsTr("Save")
                            onClicked: {
                                mask.showMask();

                                const obj = {
                                    id: popup.tagID,
                                    title: tagTitleField.text,
                                    parent: popup.parentID
                                };

                                if (popup.tagID === 0) {
                                    // URLs.service("writer").tagsUrl()
                                    CxNetwork.post(URLs.service("writer").url("tags/"), AppConfig.basicAuth(), obj, (resp)=>{
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
                                    // URLs.service("writer").tagsUrl()
                                    CxNetwork.put(URLs.service("writer").url("tags/"), AppConfig.basicAuth(), obj, (resp)=>{
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

                        Universe.Button {
                            text: qsTr("Remove")
                            onClicked: {
                                // URLs.service("writer").tagsUrl() + popup.tagID
                                CxNetwork.del(URLs.service("writer").url("tags/"+popup.tagID), AppConfig.basicAuth(), (resp)=>{
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

                        Universe.Button {
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
                        spacing: BoxTheme.spacing
                        Label { text: qsTr("Tag") }
                        TextField { id: tagTitleField }
                    }
                }
            }
        }

        Component {
            id: contentTagEditComponent

            Universe.Popup {
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
                        anchors.leftMargin: BoxTheme.leftMargin
                        anchors.rightMargin: BoxTheme.rightMargin

                        Universe.Button {
                            text: qsTr("Ok")
                            onClicked: {
                                const checkedTags = tagsModel.checkedTags();
                                popup.ok(checkedTags);
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Universe.Button {
                            text: qsTr("Close")
                            onClicked: {
                                popup.close();
                            }
                        }
                    }
                }

                body: ScrollView {
                    Flow {
                        width: popup.width
                        padding: BoxTheme.padding
                        spacing: BoxTheme.spacing
                        Repeater {
                            model: CxListModel {
                                id: tagsModel
                                roleNames: ["id","title","check"]

                                function checkedTags() {
                                    var checked = [];
                                    for (var i = 0; i < tagsModel.count(); ++i) {
                                        const obj = tagsModel.get(i);
                                        if (obj.check === true) {
                                            checked.push({id:obj.id, name: obj.name, title: obj.title });
                                        }
                                    }
                                    return checked;
                                }

                                Component.onCompleted: {
                                    mask.showMask();
                                    // URLs.service("writer").tagsUrl()
                                    CxNetwork.get(URLs.service("writer").url("tags/"), AppConfig.basicAuth(), (resp)=>{
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

                            delegate: Universe.Button {
                                text: model.title
                                checkable: true
                                checked: model.check
                                down: model.check
                                onToggled: {
                                    tagsModel.set(model.index, "check", checked)
                                }
                            }
                        }
                    }
                }

                /*
                ListView {
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
                            // URLs.service("writer").tagsUrl()
                            CxNetwork.get(URLs.service("writer").url("tags/"), AppConfig.basicAuth(), (resp)=>{
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
                */
            }
        }

        Component {
            id: changeAlertComponent

            Universe.Popup {
                id: popup
                implicitWidth: 300
                implicitHeight: 200

                signal accept();
                signal reject();

                header: ToolBar {
                    RowLayout {
                        anchors.fill: parent
                        anchors.rightMargin: BoxTheme.rightMargin

                        Universe.Button {
                            text: qsTr("Save")
                            onClicked: {
                                popup.accept();
                                popup.close();
                            }
                        }

                        Universe.Button {
                            text: qsTr("Not Save")
                            onClicked: {
                                popup.reject();
                                popup.close();
                            }
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Universe.Button {
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

        Universe.Banner {
            id: banner
            x: visible ? app.width - implicitWidth - 4 : app.width + 4
            y: app.height - implicitHeight - 4
        }

        Universe.Mask {
            id: mask
            anchors.fill: parent
            maskItem: mainPage
        }
}
