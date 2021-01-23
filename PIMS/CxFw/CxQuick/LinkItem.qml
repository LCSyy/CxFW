import QtQuick 2.15
import QtQuick.Controls 2.15
import CxQuick 0.1
import CxQuick.Controls 0.1

Item {
    id: root

    property alias text: text.text
    property var badges: undefined

    signal linkClicked(url link)

//    onBadgesChanged: {
//        for (var i in badges) {
//            const badge = badges[i];
//            root.setBadge(badge.badge_value, badge.badge_name, badge.badge_value);
//        }
//    }

//    function setBadge(text, badgeType, badgeValue) {
//        badgeComponent.createObject(badgeRow, { text: text, badgeType: badgeType, badgeValue: badgeValue })
//    }

    Text {
        id: text
        anchors.fill: parent
        anchors.leftMargin: CxTheme.baseMargin * 2
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
        width: parent.width - CxTheme.baseMargin * 2
        height: (root.badges || null) === null ? 1 : 2
        x: CxTheme.baseMargin
        color: (root.badges || null) === null ? BoxTheme.backgroundFocus : BoxTheme.color7
    }

//    Row {
//        id: badgeRow
//        anchors.left: parent.right
//        anchors.leftMargin: -(BoxTheme.leftPadding * 2 + width)
//        anchors.verticalCenter: parent.verticalCenter
//    }

//    Component {
//        id: badgeComponent
//        Badge { }
//    }
}
