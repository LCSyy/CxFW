import QtQml.Models 2.15
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import "qml" as App
import "js/app.js" as Js

ApplicationWindow {
    id: app
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

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
        readonly property string bg_light_color: '#F8F8F8'
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

            App.Button {
                text: qsTr('More')
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

            SplitView.fillWidth: true
            SplitView.fillHeight: true

            clip: true

            model: ListModel {
                id: listModel
                ListElement { dt: '2020/09/10'; name: '2020091021590000'; title: "个人信息管理"; text: "关于个人信息管理的说明。" }

                function getData(name) {
                    for (var i = 0; i < count; ++i) {
                        const item = get(i);
                        if (item.name === name) {
                            return item;
                        }
                    }
                    return null;
                }
            }

            delegate: Item {
                width: parent.width
                height: 25

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: 16
                    anchors.bottomMargin: 1
                    textFormat: Text.RichText
                    verticalAlignment: Qt.AlignVCenter

                    text: {
                        var str = '<a href="%1">%2</a>'.replace('%1',model.name)
                        str = str.replace('%2',model.title)
                        return model.dt + ' - ' + str
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

        property alias text: textArea.text

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
            this.text = ''
            meta.uuid = ''
            this.open()
        }

        function hide() {
            this.close()
            meta.uuid = ''
            this.text = ''
        }

        function edit(uuid) {
            popup();
            const data = listModel.getData(uuid);
            if (data !== null) {
                meta.uuid = data.name;
                text = data.text;
            }
        }

        Page {
            anchors.fill: parent

            QtObject {
                id: meta
                property string uuid: ''
            }

            header: Rectangle {
                width: parent.width
                height: 40
                color: theme.bg_light_color

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8

                    App.Button {
                        text: qsTr("Save")
                        onClicked: {
                            if (textArea.text.trim() === '') { return; }

                            var nowDate = new Date();

                            var obj = {
                                "dt": nowDate.format('yyyy/MM/dd'),
                                "title": app.getFirstLine(textArea.text),
                                "text": textArea.text
                            };

                            if (meta.uuid === '') {
                                meta.uuid = Js.uuid(nowDate);
                                obj["name"] = meta.uuid;
                                listModel.insert(0,obj);
                            } else {
                                var idx = 0;
                                for (; idx < listModel.count; ++idx) {
                                    if (listModel.get(idx).name === meta.uuid) {
                                        break;
                                    }
                                }

                                if (listModel.count === idx) { // gen new
                                    meta.uuid = Js.uuid(nowDate);
                                    obj["name"] = meta.uuid;
                                    listModel.insert(0,obj);
                                } else {
                                    obj["name"] = meta.uuid;
                                    listModel.set(idx,obj);
                                    listModel.move(idx,0,1);
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    App.Button {
                        text: qsTr("X")
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
