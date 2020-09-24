import QtQml.Models 2.15
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.LocalStorage 2.15
import Qt.labs.settings 1.1

import App.Type 1.0 as AppType
import "qml" as App
import "js/app.js" as Js

// status:
//   trash
//   traft
//   release
//   protect
//   ...

ApplicationWindow {
    id: app
    width: 800
    height: 520
    visible: true
    title: qsTr("writer")

    Component.onCompleted: {
        Js.initDB();
    }

    header: App.ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: AppType.Theme.baseMargin
            anchors.rightMargin: AppType.Theme.baseMargin
            anchors.bottomMargin: 2

            App.Button {
                text: qsTr('New')
                onClicked: {
                    var pp = contentComponent.createObject(app);
                    contentConnection.target = pp;
                    pp.open();
                }
            }

            App.Button {
                text: qsTr("tags")
                onClicked:  {
                    // tags.open()
                    var pp = tagsComponent.createObject(app);
                    tagNewConnection.target = pp;
                    pp.open();
                }
            }

            App.Button {
                text: qsTr("trash")
                onClicked: {
                    var pp = trashComponent.createObject(app);
                    contentConnection.target = pp;
                    pp.open();
                }
            }

            App.Button {
                text: qsTr("Settings")
                onClicked: {
                    var pp = settingsComponent.createObject(app)
                    pp.open();
                }
            }

            Item {
                Layout.fillWidth: true
            }

            App.TextField {
                visible: false
                placeholderText: qsTr('Search')
            }

            App.Button {
                text: qsTr("Refresh")
                onClicked: {
                    tagsModel.update();
                    contentsModel.update();
                }
            }
        }

        Rectangle {
            width: parent.width
            anchors.bottom: parent.bottom
            height:1
            color: AppType.Theme.bgDeepColor
        }
    }

    Settings {
        id: appSettings
        property bool contentLineWrap: true
    }

    Connections {
        id: contentConnection
        target: null

        function onOk(id) {
            // contentsModel.update();
            const oldIdx = tagsView.currentIndex;
            tagsView.currentIndex = -1;
            tagsView.currentIndex = oldIdx;
        }
    }

    Connections {
        id: tagNewConnection
        target: null

        function onOk(tagName, tagTitle) {
            tagsModel.update();
        }
    }

    AppType.ListModel {
        id: contentsModel
        roleNames: ["id","uuid","title","create_dt","update_dt"]

        Component.onCompleted: {
            update();
        }

        function update(filters) {
            clear();
            var sql = "SELECT id,uuid,title,create_dt,update_dt FROM blog WHERE status='release' ORDER BY update_dt DESC;";
            var datas = [];
            if (filters === undefined || filters.length === 0) {
                datas = Js.getData(sql);
            } else {
                sql = "SELECT blog.id,uuid,title,create_dt,update_dt "+
                      "FROM blog, json_each(blog.tags) "+
                      "WHERE blog.status = 'release' AND json_each.value IN (?) order by blog.update_dt DESC";
                datas = Js.getData(sql,filters.join(","));
            }

            for (var i in datas) {
                this.append(datas[i]);
            }
        }

        function getData(uuid) {
            for (var i = 0; i < count(); ++i) {
                const item = get(i);
                if (item.uuid === uuid) {
                    return item;
                }
            }
            return null;
        }
    }

    AppType.ListModel {
        id: tagsModel
        roleNames: ["id","name","title"]
        Component.onCompleted: {
            update();
        }

        function update() {
            clear();
            this.append({name:"_all_", title:"All"})
            const datas = Js.getData("SELECT * FROM tags ORDER BY id ASC;");
            for (var i in datas) {
                var row = datas[i];
                this.append(row);
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
                height: 25

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.bottomMargin: 1
                    textFormat: Text.RichText
                    verticalAlignment: Qt.AlignVCenter

                    text: {
                        var str = '<a href="%1">%2</a>'.replace('%1',model.uuid)
                        str = str.replace('%2',model.title)
                        return model.update_dt + ' - ' + str
                    }

                    onLinkActivated: {
                        var pp = contentComponent.createObject(app);
                        contentConnection.target = pp;
                        pp.edit(link);
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width - AppType.Theme.baseMargin * 2
                    height: 1
                    x: AppType.Theme.baseMargin
                    color: AppType.Theme.bgNormalColor
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
                color: AppType.Theme.bgNormalColor
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
                        contentsModel.update();
                    } else if (tagsView.currentIndex !== -1) {
                        contentsModel.update([tagsModel.get(tagsView.currentIndex).name]);
                    }
                }

                delegate: Rectangle {
                    width: parent === null ? 0 : parent.width
                    height: AppType.Theme.contentHeight
                    color: model.index === tagsView.currentIndex ? AppType.Theme.bgLightColor : "white"
                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        verticalAlignment: Qt.AlignVCenter
                        text: model.title
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

    Component {
        id: contentComponent

        App.Popup {
            id: popup

            implicitWidth: {
                var dw = parent.width * 0.8;
                if (dw > 640) { dw = 640; }
                return dw;
            }
            implicitHeight: parent.height * 0.8

            property bool editable: true
            signal ok(int id)

            function edit(uuid) {
                const datas = Js.getData("SELECT * FROM blog WHERE uuid = ?",[uuid]);
                if (datas.length > 0) {
                    const data = datas[0];
                    meta.uuid = data.uuid;
                    meta.id = data.id;
                    textArea.text = data.content;

                    const tags = Js.getData("select * from tags where name in (select value from blog, json_each(blog.tags) where blog.id = ?);", data.id);
                    for (var i = 0; i < tags.length; ++i) {
                        tagRepeater.model.append(tags[i]);
                    }
                }

                open();
            }

            header: App.ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    App.Button {
                        visible: popup.editable
                        text: qsTr("Save")
                        onClicked: {
                            if (textArea.text.trim() === '') { return; }

                            var tags = [];
                            for (var i = 0; i < tagRepeater.model.count(); ++i) {
                                const tagName = tagRepeater.model.get(i).name;
                                tags.push('"' + tagName + '"');
                            }

                            var nowDate = new Date();
                            const dt = nowDate.format('yyyy-MM-dd hh:mm:ss');
                            var obj = {
                                "id": meta.id,
                                "uuid": meta.uuid || '',
                                "title": Js.getFirstLine(textArea.text),
                                "content": textArea.text,
                                "tags": "[" + tags.join(",") + "]",
                                "status": "release"
                            };

                            if (meta.uuid === '') {
                                meta.uuid = Js.uuid(nowDate);
                                obj['uuid'] = meta.uuid;
                                obj["id"] = null;
                                meta.id = Js.insertRow("INSERT INTO blog(uuid,title,content,tags,create_dt,update_dt,status) VALUES(?,?,?,?,datetime('now','localtime'),datetime('now','localtime'),?)",["uuid","title","content","tags","status"],obj);
                            } else {
                                Js.updateRow("UPDATE blog SET title=?,content=?,tags=?,update_dt=datetime('now','localtime'),status=? WHERE uuid=?;",["title","content","tags","status","uuid"],obj);
                            }

                            popup.ok(meta.id)
                        }
                    }

                    App.Button {
                        visible: popup.editable
                        text: qsTr("Edit tags")
                        onClicked: {
                            var tagEditor = contentTagEditComponent.createObject(popup.contentItem);
                            var tags = [];
                            for (var i = 0; i < tagRepeater.model.count(); ++i) {
                                tags.push(tagRepeater.model.get(i));
                            }
                            contentTagEditorCon.target = tagEditor;
                            tagEditor.visible = true;
                            tagEditor.setChecked(tags);
                        }
                    }

                    App.Button {
                        visible: popup.editable
                        text: qsTr("Remove")
                        onClicked: {
                            Js.updateRow("UPDATE blog SET status = 'trash' WHERE id = ?",["id"],{id:meta.id});
                            meta.id = 0;
                            meta.uuid = "";
                            popup.ok(0);
                        }
                    }

                    App.Button {
                        visible: !popup.editable
                        text: qsTr("Recovery")
                        onClicked: {
                            Js.updateRow("UPDATE blog SET status = 'release' WHERE id = ?", ["id"], {id: meta.id});
                            meta.id = 0;
                            meta.uuid = "";
                            popup.ok(0);
                            popup.close();
                        }
                    }

                    App.Button {
                        visible: !popup.editable
                        text: qsTr("Delete")
                        onClicked: {
                            Js.removeData("DELETE FROM blog WHERE uuid = ?",meta.uuid);
                            meta.id = 0;
                            meta.uuid = "";
                            popup.ok(0);
                            popup.close();
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
                    Layout.topMargin: AppType.Theme.baseMargin / 2
                    spacing: AppType.Theme.baseMargin

                    Repeater {
                        id: tagRepeater
                        model: AppType.ListModel {
                            roleNames: ["id","name","title"]
                        }
                        delegate: App.Button {
                            text: model.title
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: AppType.Theme.bgDeepColor
                }

                ScrollView {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    TextArea {
                        id: textArea
                        readOnly: !popup.editable
                        wrapMode: appSettings.contentLineWrap === true ? TextArea.WrapAnywhere : TextArea.NoWrap
                        selectByMouse: true
                    }
                }
            }

            QtObject {
                id: meta
                property int id: 0
                property string uuid: ''
                property bool changed: false

                function reset() {
                    id = 0;
                    uuid = '';
                    changed = false;
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

            signal ok(string tagName, string tagTitle)

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

                model: AppType.ListModel {
                    id: tagModel
                    roleNames: ["id","name","title"]
                    Component.onCompleted: {
                        update();
                    }

                    function update() {
                        clear();
                        const datas = Js.getData("SELECT * FROM tags ORDER BY id ASC;");
                        for (var i in datas) {
                            var row = datas[i];
                            this.append(row);
                        }
                    }
                }

                delegate:  Item {
                    width: parent === null ? 0 : parent.width
                    height: 25

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 16
                        anchors.bottomMargin: 1
                        textFormat: Qt.RichText
                        verticalAlignment: Qt.AlignVCenter
                        text: '<a href="%1">%2</a>'.replace("%1",model.name).replace("%2",model.title)

                        onLinkActivated: {
                            var tag = tagEditComponent.createObject(popup.contentItem);
                            tagEditConn.target = tag;
                            var row = {};
                            for (var i = 0; i < tagModel.count(); ++i) {
                                row = tagModel.get(i);
                                if (row.name === model.name) {
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
                        color: AppType.Theme.bgNormalColor
                    }
                }
            }

            Connections {
                id: tagEditConn
                target: null

                function onOk(tagName, tagTitle) {
                    tagModel.update();
                    popup.ok(tagName,tagTitle);
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

                model: AppType.ListModel {
                    id: trashModel
                    roleNames: ["id","uuid","title","create_dt","update_dt"]

                    Component.onCompleted: {
                        update();
                    }

                    function update(filters) {
                        clear();
                        var datas = Js.getData("SELECT id,uuid,title,create_dt,update_dt FROM blog WHERE status<>'release' ORDER BY update_dt DESC;");
                        for (var i in datas) {
                            this.append(datas[i]);
                        }
                    }

                    function getData(uuid) {
                        for (var i = 0; i < count(); ++i) {
                            const item = get(i);
                            if (item.uuid === uuid) {
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
                        textFormat: Text.RichText
                        verticalAlignment: Qt.AlignVCenter

                        text: {
                            var str = '<a href="%1">%2</a>'.replace('%1',model.uuid)
                            str = str.replace('%2',model.title)
                            return model.update_dt + ' - ' + str
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
                        width: parent.width - AppType.Theme.baseMargin * 2
                        height: 1
                        x: AppType.Theme.baseMargin
                        color: AppType.Theme.bgNormalColor
                    }
                }
            }

            Connections {
                id: trashContentConnection
                target: null

                function onOk(uuid) {
                    popup.ok(uuid);
                    trashModel.update();
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
                    anchors.leftMargin: AppType.Theme.baseMargin
                    anchors.rightMargin: AppType.Theme.baseMargin

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
                columnSpacing: AppType.Theme.baseMargin
                rowSpacing: AppType.Theme.baseMargin

                Label {
                    Layout.fillWidth: true
                    Layout.margins: AppType.Theme.baseMargin
                    Layout.columnSpan: 2
                    // horizontalAlignment: Qt.AlignHCenter
                    text: qsTr("Content Editor")
                    font.pointSize: app.font.pointSize + 4
                    font.bold: true
                }

                CheckBox {
                    Layout.columnSpan: 2
                    text: qsTr("Line Wrap")
                    onCheckStateChanged: {
                        appSettings.contentLineWrap = (checkState === Qt.Checked);
                    }
                    Component.onCompleted: {
                        checkState = appSettings.contentLineWrap === true ? Qt.Checked : Qt.Unchecked;
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
                border.color: AppType.Theme.bgDeepColor
            }
            onAccepted: {
                ok(tagName.text,tagTitle.text);
                tagEdit.destroy();
            }
            onRejected: {
                tagEdit.destroy();
            }

            signal ok(string tagName, string tagTitle);

            function edit(row) {
                meta.id = row.id || 0;
                tagName.text = row.name;
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
                                if (meta.id === 0) {
                                    meta.id = Js.insertRow("INSERT INTO tags(name,title) VALUES(?,?);",["name","title"],{name:tagName.text, title:tagTitle.text});
                                } else {
                                    Js.updateRow("UPDATE tags SET name=?,title=? WHERE id=?",["name","title","id"],{name:tagName.text, title:tagTitle.text,id:meta.id});
                                }
                                ok(tagName.text,tagTitle.text);
                            }
                        }

                        App.Button {
                            text: qsTr("Remove")
                            onClicked: {
                                Js.removeData("DELETE FROM tags WHERE id=?",meta.id);
                                meta.id = 0;
                                ok("","")
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
                    columnSpacing: AppType.Theme.baseMargin
                    rowSpacing: AppType.Theme.baseMargin
                    Label { text: qsTr("Name") }
                    TextField { id: tagName }
                    Label { text: qsTr("Text") }
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

            function setChecked(tags) {
                var existTags = tags.map((item)=>{return item.id; });
                for (var i = 0; i < listView.model.count(); ++i) {
                    const item = listView.model.get(i);
                    if (item !== null) {
                        const itemId = item.id;
                        const idx = existTags.indexOf(itemId);
                        if (idx !== -1) {
                            listView.model.set(i,"check",true);
                            existTags.splice(idx,1);
                        }
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
                        const item = itemAtIndex(i);
                        if (item !== null && item.checkState === Qt.Checked) {
                            const obj = model.get(i);
                            if (obj !== null) {
                                checked.push({id:obj.id, name: obj.name, title: obj.title });
                            }
                        }
                    }
                    return checked;
                }

                model: AppType.ListModel {
                    roleNames: ["id","name","title","check"]
                    Component.onCompleted: {
                        const tags = Js.getData("SELECT * FROM tags;")
                        for (var i = 0; i < tags.length; ++i) {
                            var tag = tags[i];
                            tag["check"] = false;
                            append(tag);
                        }
                    }
                }
                delegate: CheckBox {
                    checkState: model.check ? Qt.Checked : Qt.Unchecked
                    text: model.title
                    onCheckStateChanged: {
                        model.check = Qt.Checked ? true : false;
                    }
                }
            }
        }
    }

}
