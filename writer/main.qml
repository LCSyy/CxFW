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

    function getFirstLine(txt) {
        if (txt.length === 0) { return ''; }
        const lineEndIdx = txt.indexOf('\n');
        if (lineEndIdx === -1) {
            return txt;
        }
        return txt.substring(0,lineEndIdx);
    }

    header: Rectangle {
        width: parent.width
        height: AppType.Theme.toolBarHeight
        color: AppType.Theme.bgNormalColor

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
            height: 2
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
            border.color: AppType.Theme.bgDeepColor
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
            id: contentPage
            anchors.fill: parent
            header: Rectangle {
                width: parent.width
                height: 40
                color: AppType.Theme.bgNormalColor

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
                        text: qsTr("Edit tags")
                        onClicked: {
                            var tagEditor = tagEditorComponent.createObject(contentPage)
                            tagEditor.visible = true
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
                anchors.margins: AppType.Theme.baseMargin
                Flow {
                    Layout.fillWidth: true
                    spacing: AppType.Theme.baseMargin

                    Repeater {
                        model: 5
                        delegate: App.Button {
                            text: modelData
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
            header: Rectangle {
                width: parent.width
                height: 40
                color: AppType.Theme.bgNormalColor

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

                header: Rectangle {
                    width: parent.width
                    height: AppType.Theme.toolBarHeight
                    color: AppType.Theme.bgLightColor

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
        id: tagEditorComponent
        App.Popup {
            id: popup

            onVisibleChanged: {
                if (visible === false)
                    popup.destroy();
            }

            header: Rectangle {
                width: parent.width
                height: AppType.Theme.toolBarHeight
                color: AppType.Theme.bgNormalColor
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    App.Button {
                        text: qsTr("Ok")
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    App.Button {
                        text: qsTr("Close")
                        onClicked: {
                            popup.visible = false;
                        }
                    }
                }
            }

            body: Text {
                text: "Hello"
            }
        }
    }
}
