import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import CxQuick 0.1

T.ComboBox {
    id: control

    leftPadding: BoxTheme.leftPadding
    rightPadding: BoxTheme.rightPadding
    spacing: BoxTheme.spacing
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    background: Rectangle {
        implicitWidth: BoxTheme.baseWidth
        implicitHeight: BoxTheme.baseHeight
        border.color: control.pressed ? BoxTheme.backgroundFocus : BoxTheme.backgroundInActive
        border.width: control.visualFocus ? 2 : 1
        radius: 2
    }

    contentItem: Text {
        leftPadding: BoxTheme.leftPadding
        rightPadding: control.indicator.width + control.spacing

        text: control.displayText
        font: control.font
        color: "black"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    indicator: Canvas {
        id: canvas
        x: control.width - width - control.rightPadding
        y: control.topPadding + (control.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"

        Connections {
        target: control
            function onPressedChanged() { canvas.requestPaint(); }
        }

        onPaint: {
            var context = canvas.getContext("2d");
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = control.pressed ? BoxTheme.backgroundFocus : BoxTheme.backgroundInActive;
            context.fill();
        }
    }

    delegate: ItemDelegate {
        width: control.width
        height: BoxTheme.baseHeight
        contentItem: Text {
            text: control.textRole === "" ? modelData : model[control.textRole]
            color: "black"
            font: control.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        highlighted: control.highlightedIndex === index
    }

    popup: Popup {
        width: control.width
        implicitHeight: contentItem.implicitHeight + 2
        padding: 1

        contentItem: ListView {
            id: itemView
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            border.color: BoxTheme.backgroundInActive
            radius: 2
        }
    }
}
