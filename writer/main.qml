import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


Window {
    id: app
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    QtObject {
        id: theme
        readonly property string bg_depth_color: '#222'
        readonly property string bg_normal_color: '#aaa'
        readonly property string bg_light_color: '#F8F8F8'
    }

    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 8
            Layout.rightMargin: 8

            ToolButton {
                text: qsTr('New')
            }

            ToolButton {
                text: qsTr('Stat')
            }

            ToolButton {
                text: qsTr('More')
            }

            Item {
                Layout.fillWidth: true
            }

            TextField {
                placeholderText: qsTr('Search')
            }

            ToolButton {
                text: qsTr('Search')
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 8
            color: theme.bg_normal_color
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {

                Layout.fillWidth: true
                Layout.fillHeight: true

                clip: true

                model: ListModel {
                    ListElement { dt: '2020/10/11'; name: 'five'; text: "linux基础 - bash shell" }
                    ListElement { dt: '2020/10/01'; name: 'four'; text: "zip.cxx 自己实现的简易zip" }
                    ListElement { dt: '2020/10/01'; name: 'three'; text: "用nodejs实现http上传文件到服务器" }
                    ListElement { dt: '2020/09/29'; name: 'two'; text: "个人文档，参考资料，实用工具，日程管理" }
                    ListElement { dt: '2020/09/23'; name: 'one'; text: "个人信息管理" }
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
                            var str = '<a href="/%1">%2</a>'.replace('%1',model.name)
                            str = str.replace('%2',model.text)
                            return model.dt + ' - ' + str
                        }

                        onLinkActivated: {
                            console.log(link)
                        }
                    }

                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width
                        height: 1
                        color: theme.bg_normal_color
                    }
                }
            }

            Column {
                Layout.minimumWidth: 150
                Layout.fillHeight: true

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

    }
}
