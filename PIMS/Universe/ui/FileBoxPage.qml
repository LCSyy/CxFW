import QtQuick 2.15
import QtQuick.Controls 2.15

import Universe 0.1

SplitView {
    orientation: Qt.Horizontal

    ScrollView {
        SplitView.fillWidth: true
        SplitView.fillHeight: true
        ListView {
            boundsBehavior: ListView.StopAtBounds
            boundsMovement: ListView.FollowBoundsBehavior

            model: CxListModel {
                id: filesModel
                roleNames: ["url"]
            }

            delegate: Text {
                text: model.url
            }
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
                    for (var i in drop.urls) {
                        filesModel.append({url:drop.urls[i]})
                    }
                }
            }
        }
    }
}
