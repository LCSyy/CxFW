import QtQuick 2.12
import QtQuick.Controls 2.12

/*!
  \qmltype FormLayout

  \qml
  FormLayout {
    anchors.fill: parent
    spacing: 10
    margins: 10

    FormItem {
      text: "User Name"

      TextField {}
    }

    FormItem {
      text: "Code"
      TextEdit {}
    }
  }
  \endqml
*/
Container {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            contentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding)

    spacing: 10

    contentItem: ListView {
        id: listView
        model: control.contentModel
        currentIndex: control.currentIndex

        spacing: control.spacing
        orientation: ListView.Vertical
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.AutoFlickIfNeeded
        snapMode: ListView.SnapToItem

        property int labelWidth: 10
    }

    background: Rectangle {
        color: control.palette.window
    }


    Component.onCompleted: {
        for(var i = 0; i < listView.count; ++i) {
            listView.currentIndex = i;
            listView.currentItem.updateLabelWidth();
        }
    }
}
