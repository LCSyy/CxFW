import QtQuick 2.15
import QtQuick.Controls 2.15
import "../qml/BoxTheme.js" as BoxTheme

Pane {
    id: page
    signal backToLogin()

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
        text: qsTr("Universe Home")
        font.pointSize: Qt.application.font.pointSize + 8
        font.bold: true
    }

    Button {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: BoxTheme.margins
        text: qsTr("Go to Login.")
        onClicked: page.backToLogin()
    }
}
