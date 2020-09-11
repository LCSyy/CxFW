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
    title: qsTr("Hello World")

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
        readonly property string bg_depth_color: '#222'
        readonly property string bg_normal_color: '#aaa'
        readonly property string bg_light_color: '#E2E2E2'
        readonly property string bg_lighter_color: '#F8F8F8'
    }

    header: Rectangle {
        width: parent.width
        height: 40

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin:8
            anchors.bottomMargin: 8

            App.Button {
                text: qsTr('New')
                onClicked: {
                    writer.popup()
                }
            }

            Item {
                Layout.fillWidth: true
            }

            App.TextField {
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

                Component.onCompleted: {
                    update();
                }

                function update() {
                    clear();
                    const datas = Js.getData();
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

        QtObject {
            id: meta
            property int id: 0
            property string uuid: ''
        }

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
            textArea.text = ''
            meta.uuid = ''
            meta.id = 0
            this.open()
        }

        function hide() {
            this.close()
            meta.uuid = ''
            meta.id = 0
            textArea.text = ''
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
                                "tags": "",
                                "update_dt": dt
                            };

                            if (meta.uuid !== '') {
                                var idx = 0;
                                for (; idx < listModel.count(); ++idx) {
                                    if (listModel.get(idx).uuid === meta.uuid) {
                                        break;
                                    }
                                }

                                if (idx < listModel.count()) {
                                    listModel.set(idx,obj);
                                    listModel.move(idx,0);
                                } else {
                                    meta.uuid = '';
                                }
                            }

                            if (meta.uuid === '') {
                                meta.uuid = Js.uuid(nowDate);
                                obj['uuid'] = meta.uuid;
                                obj['create_dt'] = dt;
                                obj["id"] = null;
                                listModel.insert(0,obj);
                            }

                            meta.id = Js.saveData(obj);
                            listModel.update();
                        }
                    }

                    App.Button {
                        text: qsTr("Remove")
                        onClicked: {
                            Js.removeData(meta.uuid);
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

            ScrollView {
                anchors.fill: parent
                TextArea {
                    id: textArea
                }
            }
        }
    }
}
