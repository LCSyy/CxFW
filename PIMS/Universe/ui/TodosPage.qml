import QtQuick 2.15
import QtQuick.Controls 2.15

Pane {

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    background: Rectangle {
        color: "white"
    }

    Label {
        anchors.fill: parent
        verticalAlignment: Qt.AlignVCenter
        horizontalAlignment: Qt.AlignHCenter
        text: qsTr("Coming Soon ...")
        font.pointSize: Qt.application.font.pointSize + 8
        font.bold: true
    }
}
