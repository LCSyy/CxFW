import QtQuick 2.15
import QtQuick.Controls 2.15
import CxQuick 0.1
import CxQuick.Controls 0.1

Item {
    id: root

    property alias text: title.text
    property alias dateTime: dateTime.text
    property var badges: undefined

    signal linkClicked(url link)

    implicitHeight: title.height + title.anchors.topMargin + title.anchors.bottomMargin
                    + dateTime.height + dateTime.anchors.topMargin + dateTime.anchors.bottomMargin
                    + line.height + line.anchors.topMargin + line.anchors.bottomMargin

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
        id: title
        anchors.top: parent.top
        anchors.topMargin: CxTheme.baseMargin
        anchors.left: parent.left
        anchors.leftMargin: CxTheme.baseMargin * 2
        textFormat: Text.RichText
        verticalAlignment: Qt.AlignVCenter
        font.pointSize: Qt.application.font.pointSize + 2
        font.bold: true

        onLinkActivated: {
            root.linkClicked(link);
        }
    }

    Text {
        id: dateTime
        anchors.top: title.bottom
        anchors.topMargin: CxTheme.baseMargin + BoxTheme.spacing
        anchors.left: parent.left
        anchors.leftMargin: CxTheme.baseMargin * 2
        textFormat: Text.RichText
        verticalAlignment: Qt.AlignVCenter
        font.pointSize: Qt.application.font.pointSize + 2
    }

    Rectangle {
        id: line
        anchors.top: dateTime.bottom
        anchors.topMargin: BoxTheme.spacing
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
