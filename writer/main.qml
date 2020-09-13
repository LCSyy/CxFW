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
    color: theme.bg_normal_color

    Component.onCompleted: {
        Js.initDB();
    }

    function getFirstLine(txt) {
        if (txt.length === 0) { return ''; }
        const lineEndIdx = txt.indexOf('\n');
        if (lineEndIdx === -1) {
            return txt;
        }
        return txt.substring(0,lineEndIdx);
    }

    QtObject {
        id: theme
        readonly property int base_margin: 8
        readonly property int content_row_height: 25
        readonly property int toolbar_height: 40
        readonly property string bg_depth_color: '#222'
        readonly property string bg_normal_color: '#aaa'
        readonly property string bg_light_color: '#E2E2E2'
        readonly property string bg_lighter_color: '#F8F8F8'
    }

    header: Rectangle {
        width: parent.width
        height: theme.toolbar_height

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            anchors.bottomMargin: 8

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

            Item {
                Layout.fillWidth: true
            }

            App.TextField {
                visible: false
                placeholderText: qsTr('Search')
            }
        }

        Rectangle {
            width: parent.width
            anchors.bottom: parent.bottom
            height: 8
            color: theme.bg_normal_color
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

                function update() {
                    clear();
                    const datas = Js.getData("SELECT * FROM blog ORDER BY update_dt DESC;");
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
                    color: theme.bg_normal_color
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
                color: theme.bg_normal_color
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

                model: [
                    'notes',
                    'resources',
                    'timer',
                    'works',
                    'miscs'
                ]

                delegate: Item {
                    width: parent.width
                    height: 15

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 8
                        verticalAlignment: Qt.AlignVCenter
                        text: '<a href="/cate">' + modelData + '</a>'

                        onLinkActivated: {
                            console.log(link)
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
            border.color: theme.bg_depth_color
        }

        function popup() {
            meta.reset();
            this.open();
        }

        function hide() {
            this.close();
            meta.reset();
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
            anchors.fill: parent
            header: Rectangle {
                width: parent.width
                height: 40
                color: theme.bg_lighter_color

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    App.Button {
                        text: qsTr("Save")
                        onClicked: {
                            if (textArea.text.trim() === '') { return; }

                            var nowDate = new Date();
                            const dt = nowDate.format('yyyy-MM-dd hh:mm:ss');
                            var obj = {
                                "id": meta.id,
                                "uuid": meta.uuid || '',
                                "title": app.getFirstLine(textArea.text),
                                "content": textArea.text,
                                "tags": null,
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

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: theme.base_margin
                GridLayout {
                    Layout.fillWidth: true
                    columns: 10
                    columnSpacing: theme.base_margin
                    rowSpacing: theme.base_margin

                    Repeater {
                        model: ["rust","story","+"]
                        delegate: App.Button {
                            text: modelData
                        }
                    }
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
            border.color: theme.bg_depth_color
        }

        Page {
            id: tagsPage
            anchors.fill: parent
            header: Rectangle {
                width: parent.width
                height: 40
                color: theme.bg_lighter_color

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
                    width: parent.width
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
                        color: theme.bg_normal_color
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
                border.color: theme.bg_depth_color
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

                header: Rectangle {
                    width: parent.width
                    height: 40
                    color: theme.bg_lighter_color

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
                                ok(tagName.text, tagTitle.text);
                            }
                        }

                        App.Button {
                            text: qsTr("Remove")
                            onClicked: {
                                console.log(meta.id);
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
                    columnSpacing: theme.base_margin
                    rowSpacing: theme.base_margin
                    Label { text: qsTr("Name") }
                    TextField { id: tagName }
                    Label { text: qsTr("Text") }
                    TextField { id: tagTitle }
                }
            }
        }
    }
}
