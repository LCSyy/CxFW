import QtQuick 2.13
import QtQuick.Controls 2.13
import QtQuick.Templates 2.13 as T

T.TextField {
    id: control

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || contentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             topPadding + bottomPadding)

    padding: 6
    verticalAlignment: TextInput.AlignVCenter
    placeholderText: "Text"
    placeholderTextColor: "#458912"

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 30
        border.color: control.activeFocus ? "#669BBB" : "#447999"
    }
}
