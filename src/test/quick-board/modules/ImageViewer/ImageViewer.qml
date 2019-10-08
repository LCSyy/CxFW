import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.3

Page {
    id: _page

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
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }
}
