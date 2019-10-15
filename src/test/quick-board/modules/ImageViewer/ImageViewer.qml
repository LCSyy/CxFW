import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3

Page {
    id: _page
    clip: true
    anchors.fill: parent

    property string moduleName: ""

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            spacing: 0

            ToolButton {
                text: "Open"
                onClicked: {
                    _fileDlg.open()
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
            }
        }
    }

    FileDialog {
        id: _fileDlg
        title: "Select Image File"
        nameFilters: ["Image files (*.jpg *.png)"]

        onAccepted: {
            _viewer.source = fileUrl
        }
    }

    Image {
        id: _viewer
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        property int scaleNum: 10
        readonly property int scaleMin: 1
        readonly property int scaleMax: 20

        anchors.fill: parent
        drag.target: _viewer
        drag.axis: Drag.XAxis | Drag.YAxis
        drag.minimumX: 0
        drag.maximumX: _page.width - 10
        drag.minimumY: 0
        drag.maximumY: _page.height - 50

        onWheel: {
            if(_viewer.source !== '') {
                if(wheel.angleDelta.y > 0 && scaleNum < scaleMax) {
                    scaleNum += 1;
                } else if(wheel.angleDelta.y < 0 && scaleNum > scaleMin) { // zoom out
                    scaleNum -= 1;
                }
                _viewer.scale = scaleNum * 0.1;
            }
        }
    }
}
