import QtQuick 2.15
import QtQuick.Controls 2.15
import CxFw.CxQuick 0.1

Item {
    id: root

    property alias text: title.text
    property alias dateTime: dateTime.text
    property var badges: undefined

    signal linkClicked(url link)

    implicitHeight: title.height + title.anchors.topMargin + title.anchors.bottomMargin
                    + dateTime.height + dateTime.anchors.topMargin + dateTime.anchors.bottomMargin
                    + line.height + line.anchors.topMargin + line.anchors.bottomMargin

    Text {
        id: title
        anchors.top: parent.top
        anchors.topMargin: CxQuick.margins
        anchors.left: parent.left
        anchors.leftMargin: CxQuick.margins * 2
        anchors.right: parent.right
        textFormat: Text.RichText
        verticalAlignment: Qt.AlignVCenter
        font.pointSize: Qt.application.font.pointSize + 2
        font.bold: true
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere

        onLinkActivated: {
            root.linkClicked(link);
        }
    }

    Text {
        id: dateTime
        anchors.top: title.bottom
        anchors.topMargin: CxQuick.margins + CxQuick.spacing
        anchors.left: parent.left
        anchors.leftMargin: CxQuick.margins * 2
        textFormat: Text.RichText
        verticalAlignment: Qt.AlignVCenter
        font.pointSize: Qt.application.font.pointSize + 2
    }

    Rectangle {
        id: line
        anchors.top: dateTime.bottom
        anchors.topMargin: CxQuick.spacing
        width: parent.width - CxQuick.margins * 2
        height: (root.badges || null) === null ? 1 : 2
        x: CxQuick.margins
        color: (root.badges || null) === null ? CxQuick.background : CxQuick.backgroundActive
    }
}
