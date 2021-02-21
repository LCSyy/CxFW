import QtQuick 2.15
import QtQuick.Controls 2.15

import Universe 0.1
import "../qml" as Universe
import "../qml/AppConfigs.js" as Config

SplitView {
    id: page
    orientation: Qt.Horizontal

    CxListModel {
        id: filesModel
        roleNames: ["fileName"]
        Component.onCompleted: update()

        function update() {
            CxNetwork.get(URLs.service("sys").url("/fs/all/"), Config.basicAuth(), (resp) => {
                              try {
                                  filesModel.clear();
                                  const res = JSON.parse(resp);
                                  if (res.err === null) {
                                      for (var i in res.body) {
                                          const fileName = res.body[i] || "";
                                          if (fileName.length > 0) {
                                              filesModel.append({fileName:fileName});
                                          }
                                      }
                                  }
                              } catch(e) {
                                  console.log('FileBoxPage.qml - CxListModel::update',JSON.stringify(e));
                              }
                          });
        }
    }

    ScrollView {
        SplitView.fillWidth: true
        SplitView.fillHeight: true
        ListView {
            boundsBehavior: ListView.StopAtBounds
            boundsMovement: ListView.FollowBoundsBehavior
            model: filesModel
            delegate: fileComponent
        }
    }

    Item {
        SplitView.fillWidth: true
        SplitView.fillHeight: true
        SplitView.minimumWidth: 160
        Image {
            opacity: 0.2
            anchors.centerIn: parent
            width: parent.width * 0.8 <= 200 ? parent.width * 0.8 <= 40 ? 40 : parent.width * 0.8 : 200
            height: width
            fillMode: Image.PreserveAspectFit
            source: "qrc:/icons/box-open.svg"
        }
        DropArea {
            anchors.fill: parent
            onDropped: {
                if (drop.hasUrls) {
                    var pp = maskComponent.createObject(page);
                    pp.showMask();
                    var ress = [];
                    for (var i in drop.urls) {
                        const res = drop.urls[i]
                        ress.push(res);
                        filesModel.append({fileName:Sys.fileName(res)});
                    }
                    CxNetwork.upload(URLs.service("sys").url("/fs/"), Config.basicAuth(), ress, (resp)=>{
                                         console.log('[upload reply] ' + JSON.stringify(resp));
                                         filesModel.update();
                                         pp.hideMask();
                                     })
                }
            }
        }
    }

    Component {
        id: fileComponent
        Item {
            width: parent !== null ? parent.width : 100
            height: 34
            Text {
                text: "<a href=\"{0}\">{1}</a>".replace("{0}", model.fileName).replace("{1}", model.fileName)
                anchors.fill: parent
                anchors.bottomMargin: 1
                color: "black"
                leftPadding: 8
                verticalAlignment: Qt.AlignVCenter
                font.pointSize: Qt.application.font.pointSize + 2

                onLinkActivated: {
                    var pp = optionComponent.createObject(page)
                    pp.fileName = link
                    pp.open()
                }
            }

            Rectangle {
                width: parent.width
                anchors.bottom: parent.bottom
                height: 1
                color: "black"
            }
        }
    }

    Component {
        id: optionComponent

        Universe.Popup {
            id: popup
            implicitWidth: 300
            implicitHeight: 200
            property string fileName: ""

            body: Item {
                Row {
                    anchors.centerIn: parent
                    Button {
                        text: qsTr("Download")
                        onClicked: {
                            if (popup.fileName.length > 0) {
                                CxNetwork.download(URLs.service("sys").url("/fs/", "name="+popup.fileName), Config.basicAuth(), "name", (resp)=>{
                                                       console.log('[download reply] ' + resp);
                                                   });
                            }
                        }
                    }
                    Button {
                        text: qsTr("Delete")
                        onClicked: {
                            if (popup.fileName.length > 0) {
                                CxNetwork.del(URLs.service("sys").url("/fs/", "name="+popup.fileName), Config.basicAuth(), (resp)=>{
                                                  console.log('[del file reply] ' + resp);
                                                  filesModel.update();
                                                  popup.close();
                                              });
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: maskComponent

        Universe.Mask {}
    }
}
