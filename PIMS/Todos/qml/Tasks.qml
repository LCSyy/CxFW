import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import CxQuick 0.1 as Cx
import "../Controls" as Cx

Cx.Popup {
    id: popup
    implicitWidth: parent.width * 0.8
    implicitHeight: parent.height * 0.8

    signal ok(int taskID)

    Connections {
        id: taskSaveConnection
        target: null

        function onOk(taskID) {
            taskModel.update();
            popup.ok(taskID);
        }
    }

    function openTaskEditor(row) {
        var com = Qt.createComponent("qrc:/qml/TaskEdit.qml");
        if (com.status === Component.Ready) {
            var pp = com.createObject(popup.contentItem);
            taskSaveConnection.target = pp;
            pp.taskID = row.id || 0;
            pp.taskTitle = row.title || "";
            pp.open();
        } else if (com.status === Component.Error) {
            console.info(com.errorString());
        } else {
            com.statusChanged.connect(()=>{
                                          var pp = com.createObject(popup.contentItem);
                                          taskSaveConnection.target = pp;
                                          pp.taskID = row.id || 0;
                                          pp.taskTitle = row.title || "";
                                          pp.open();
                                      });
        }
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8

            Button {
                text: qsTr("New")
                onClicked: popup.openTaskEditor({})
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
        id: taskList
        clip: true
        boundsBehavior: Flickable.DragOverBounds

        model: Cx.ListModel {
            id: taskModel
            roleNames: ["id","title","created_at","remark"]
            Component.onCompleted: {
                update();
            }

            function update() {
                mask.showMask();
                Cx.Network.get(URLs.url("/tasks/"), appSettings.basicAuth(), (resp)=>{
                                   clear();
                                   try {
                                       const res = JSON.parse(resp);
                                       const body = res.body;
                                       for (var i in body) {
                                           var row = body[i];
                                           taskModel.append(row);
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

                onLinkActivated: popup.openTaskEditor(taskList.model.get(model.index));
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

}
