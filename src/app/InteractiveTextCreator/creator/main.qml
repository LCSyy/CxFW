import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

ApplicationWindow {
    id: app
    visible: true
    width: 480
    height: 320
    title: qsTr("Hello World")
    Component.onCompleted: {
        showMaximized()
    }

    SplitView {
        anchors.fill: parent
        orientation: Qt.Horizontal

        Rectangle {
            color: "#894613"
            implicitWidth: 300
        }

        Rectangle {
            implicitWidth: 300
            SplitView.fillWidth: true
            ScrollView {
                anchors.fill: parent
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                TextArea {
                    wrapMode: TextArea.WrapAtWordBoundaryOrAnywhere
                }
            }
        }

        Rectangle {
            color: "#234678"
            implicitWidth: 200
        }
    }
}
