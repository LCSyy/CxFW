import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Container {
    id: container
    width: 56
    currentIndex: 0

    signal otherButtonClicked(string name)
    property string currentPageName: ""

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    Component.onCompleted: {
        if (currentIndex >= 0) {
            currentPageName = naviModel.get(currentIndex).name
        }
    }

    contentItem: Column {
        width: 56
        ListView {
            width: parent.width
            height: parent.height - settingsButton.height
            model: container.contentModel
            snapMode: ListView.SnapOneItem
            boundsBehavior: ListView.StopAtBounds
            boundsMovement: Flickable.FollowBoundsBehavior
        }

        Button {
            id: settingsButton
            width: 56
            icon.source: "qrc:/icons/cog.svg"
            icon.width: 20
            icon.height: 20
            display: AbstractButton.IconOnly
            text: qsTr("Settings")

            onClicked: container.otherButtonClicked("settings")
        }
    }

    background: Rectangle {
        color: container.palette.button
    }

    ButtonGroup { id: buttonGroup }

    Repeater {
        model: ListModel {
            id: naviModel
            ListElement { name: "home"; icon: "qrc:/icons/home.svg"; text: qsTr("Home") }
            ListElement { name: "writer"; icon: "qrc:/icons/pen-nib.svg"; text: qsTr("Writer") }
            ListElement { name: "frags"; icon: "qrc:/icons/comments.svg"; text: qsTr("Frags") }
            ListElement { name: "todos"; icon: "qrc:/icons/th-list.svg"; text: qsTr("Todos") }
            ListElement { name: "file-box"; icon: "qrc:/icons/box-open.svg"; text: qsTr("Box") }
            ListElement { name: "help"; icon: "qrc:/icons/question-circle.svg"; text: qsTr("Help") }
        }

        Button {
            width: 56
            icon.source: model.icon
            icon.width: 20
            icon.height: 20
            display: AbstractButton.TextUnderIcon
            text: model.text
            checkable: true
            checked: container.currentIndex === model.index
            ButtonGroup.group: buttonGroup

            onCheckedChanged: {
                if (checked && container.currentIndex !== model.index) {
                    container.currentIndex = model.index
                    container.currentPageName = model.name
                }
            }
        }
    }
}
