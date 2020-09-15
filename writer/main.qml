import QtQml.Models 2.15
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import App.Type 1.0 as AppType
import "qml" as App
import "js/app.js" as Js

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
                    writer.popup()
                }
            }

            App.Button {
                text: qsTr("tags")
                onClicked:  {
                    tags.open()
                }
            }

            App.Button {
                text: qsTr("popup")
                onClicked: {
                    var component = Qt.createComponent("qrc:/qml/Popup.qml")
                    if (component.status === Component.Ready) {
                        var pp = component.createObject(app)
                        pp.visible = true
                    }
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
                    categoriesModel.update();
                    listModel.update();
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

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        ListView {
            id: contentListView
            SplitView.fillWidth: true
            SplitView.fillHeight: true

            clip: true

            model: AppType.ListModel {
                id: listModel
                roleNames: ["id","uuid","title","content","create_dt","update_dt"]

                Component.onCompleted: {
                    update();
                }

                function update(filters) {
                    clear();
                    var sql = "SELECT * FROM blog ORDER BY update_dt DESC;";
                    var datas = [];
                    if (filters === undefined || filters.length === 0) {
                        datas = Js.getData(sql);
                    } else {
                        sql = "SELECT blog.id,uuid,title,content,create_dt,update_dt FROM blog, json_each(blog.tags) WHERE json_each.value IN (?)";
                        datas = Js.getData(sql,filters.join(","));
                    }

                    for (var i in datas) {
                        var row = datas[i];
                        this.append(row);
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
                        writer.edit(link);
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
                width: parent.width
                height: parent.height - 25
                clip: true

                model: AppType.ListModel {
                    id: categoriesModel
                    roleNames: ["id","name","title"]

                    Component.onCompleted: update()

                    function update() {
                        clear();
                        this.append({id:0,name:"_all_",title:"All"});
                        const datas = Js.getData("SELECT * FROM tags ORDER BY id ASC;");
                        for (var i in datas) {
                            this.append(datas[i]);
                        }
                    }
                }

                delegate: Item {
                    width: parent.width
                    height: AppType.Theme.contentHeight

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        verticalAlignment: Qt.AlignVCenter
                        text: '<a href="?">'.replace("?",model.name) + model.title + '</a>'

                        onLinkActivated: {
                            console.log(link)
                            if (link === "_all_") {
                                listModel.update();
                            } else {
                                listModel.update([link]);
                            }
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: writer

        modal: true
        anchors.centerIn: parent
        padding: 8
        implicitWidth: {
            var dw = parent.width * 0.8;
            if (dw > 640) { dw = 640; }
            return dw;
        }
        implicitHeight: parent.height * 0.8

        background: Rectangle {
            radius: 4
            border.width: 1
            border.color: AppType.Theme.bgDeepColor
        }

        function popup() {
            meta.reset();
            tagRepeater.model.clear();
            textArea.text = '';
            this.open();
        }

        function hide() {
            this.close();
            meta.reset();
            tagRepeater.model.clear();
            textArea.text = '';
        }

        function edit(uuid) {
            popup();
            const data = listModel.getData(uuid);
            if (data !== null) {
                meta.uuid = data.uuid;
                meta.id = data.id;
                textArea.text = data.content;
            }

            const tags = Js.getData("select * from tags where name in (select value from blog, json_each(blog.tags) where blog.id = ?);", data.id);
            for (var i = 0; i < tags.length; ++i) {
                tagRepeater.model.append(tags[i]);
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

        Page {
            id: contentPage
            anchors.fill: parent
            header: App.ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    App.Button {
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
                                "create_dt": null,
                                "update_dt": dt
                            };

                            if (meta.uuid !== '') {
                                var idx = 0;
                                for (; idx < listModel.count(); ++idx) {
                                    if (listModel.get(idx).uuid === meta.uuid) {
                                        break;
                                    }
                                }

                                if (idx >= listModel.count()) {
                                    meta.uuid = '';
                                }
                            }

                            if (meta.uuid === '') {
                                meta.uuid = Js.uuid(nowDate);
                                obj['uuid'] = meta.uuid;
                                obj['create_dt'] = dt;
                                obj["id"] = null;
                                meta.id = Js.insertRow("INSERT INTO blog(uuid,title,content,tags,create_dt,update_dt) VALUES(?,?,?,?,?,?)",["uuid","title","content","tags","create_dt","update_dt"],obj);
                            } else {
                                Js.updateRow("UPDATE blog SET title=?,content=?,tags=?,update_dt=? WHERE id=?;",["title","content","tags","update_dt","id"],obj);
                            }

                            listModel.update();
                        }
                    }

                    App.Button {
                        text: qsTr("Edit tags")
                        onClicked: {
                            var tagEditor = contentTagEditComponent.createObject(contentPage);
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
                        text: qsTr("Remove")
                        onClicked: {
                            Js.removeData("DELETE FROM blog WHERE id=?",meta.id);
                            meta.id = 0;
                            meta.uuid = "";
                            listModel.update();
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    App.Button {
                        text: qsTr("Close")
                        onClicked: writer.hide()
                    }
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
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: AppType.Theme.baseMargin
                Flow {
                    Layout.fillWidth: true
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
                    }
                }
            }
        }
    }

    Popup {
        id: tags
        modal: true
        anchors.centerIn: parent
        padding: 8
        implicitWidth: {
            var dw = parent.width * 0.8;
            if (dw > 640) { dw = 640; }
            return dw;
        }
        implicitHeight: parent.height * 0.8
        background: Rectangle {
            radius: 4
            border.width: 1
            border.color: AppType.Theme.bgDeepColor
        }

        Page {
            id: tagsPage
            anchors.fill: parent
            header: App.ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    App.Button {
                        text: qsTr("New")
                        onClicked: {
                            var tag = tagEditor.createObject(tagsPage);
                            tagEditConn.target = tag;
                            tag.visible = true;
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    App.Button {
                        text: qsTr("Close")
                        onClicked: tags.close()
                    }
                }
            }

            Connections {
                id: tagEditConn
                target: null

                function onOk(tagName, tagTitle) {
                    tagModel.update();
                }
            }

            ListView {
                id: tagList
                anchors.fill: parent

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
                            var tag = tagEditor.createObject(tagsPage);
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
        }
    }

    Component {
        id: tagEditor

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
                                tagModel.update();
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
                }
            }
        }
    }
}
