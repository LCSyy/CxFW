import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import CxFw.CxStyle 0.1

T.ComboBox {
    id: control

    leftPadding: 4
    rightPadding: 4
    spacing: 4
    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)
    background: Rectangle {
        implicitWidth: 40
        implicitHeight: 25
        border.color: control.pressed ? "grey" : "white"
        border.width: control.visualFocus ? 2 : 1
        radius: 2
    }

    contentItem: Text {
        leftPadding: 4
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
            context.fillStyle = control.pressed ? "grey" : "white";
            context.fill();
        }
    }

    delegate: ItemDelegate {
        width: control.width
        height: 25
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
            border.color: "grey"
            radius: 2
        }
    }
}
