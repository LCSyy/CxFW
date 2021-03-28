import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import CxQuick 0.1 as Cx
import "../Controls" as Cx

Cx.Popup {
    id: popup

    implicitWidth: parent.width
    implicitHeight: parent.height * 0.8

    signal ok(int taskID);

    property int taskID: 0
    property alias taskTitle: taskTitleField.text

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Cx.Theme.baseMargin
            anchors.rightMargin: Cx.Theme.baseMargin

            Button {
                text: qsTr("Save")
                onClicked: {
                    mask.showMask();

                    const obj = {
                        id: popup.taskID,
                        title: popup.taskTitle,
                    };

                    if (popup.taskID === 0) {
                        Cx.Network.post(URLs.url("/tasks/"), appSettings.basicAuth(), obj, (resp)=>{
                                            try {
                                                const res = JSON.parse(resp);
                                                const body = res.body;
                                                popup.taskID = body.id;
                                                popup.taskTitle = body.title;
                                            } catch(e) {
                                                console.log(e);
                                            }
                                            popup.ok(popup.taskID);
                                            mask.hideMask();
                                        });
                    } else {
                        Cx.Network.put(URLs.url("/tasks/{id}".replace("{id}",popup.taskID)),
                                       appSettings.basicAuth(),
                                       obj,
                                       (resp)=>{
                                            try {
                                                const res = JSON.parse(resp);
                                                const body = res.body;
                                                popup.taskID = body.id;
                                                popup.taskTitle = body.title;
                                            } catch(e) {
                                                console.log(e);
                                            }
                                           popup.ok(popup.taskID);
                                            mask.hideMask();
                                        });
                    }
                }
            }

            Button {
                text: qsTr("Remove")
                onClicked: {
                    Cx.Network.del(URLs.url("/tasks/{id}".replace("{id}", popup.taskID)),
                                   appSettings.basicAuth(),
                                   (resp)=>{
                                       popup.taskID = 0;
                                       popup.taskTitle = "";
                                       popup.close();
                                       popup.ok(popup.taskID);
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
            spacing: Cx.Theme.baseMargin
            Label {
                text: qsTr("Task")
            }
            TextField {
                id: taskTitleField
            }
        }
    }
}
