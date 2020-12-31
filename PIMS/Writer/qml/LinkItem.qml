import QtQuick 2.15
import QtQuick.Controls 2.15
import CxQuick 0.1

Item {
    id: root

    property alias text: text.text
    property Component badgeComponent: Qt.createComponent("Badge.qml")

    signal linkClicked(url link)

    function setBadge(text, badgeType, badgeValue) {
        badgeComponent.createObject(badgeRow, { text: text, badgeType: badgeType, badgeValue: badgeValue })
    }

    Text {
        id: text
        anchors.fill: parent
        anchors.leftMargin: Theme.baseMargin * 2
        anchors.bottomMargin: 1
        textFormat: Text.RichText
        verticalAlignment: Qt.AlignVCenter
        font.pointSize: Qt.application.font.pointSize + 2

        onLinkActivated: {
            root.linkClicked(link);
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width - Theme.baseMargin * 2
        height: 1
        x: Theme.baseMargin
        color: Theme.bgNormalColor
    }

    Row {
        id: badgeRow
        anchors.left: parent.right
        anchors.leftMargin: -(Theme.baseMargin * 2 + width)
        anchors.verticalCenter: parent.verticalCenter
    }
}
