import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Templates 2.12 as T

T.TextField {
    id: control

    implicitWidth: implicitBackgroundWidth + leftInset + rightInset
                   || contentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             contentHeight + topPadding + bottomPadding,
                             topPadding + bottomPadding)

    padding: 6
    verticalAlignment: TextInput.AlignVCenter

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 30
        border.color: control.activeFocus ? "#669BBB" : "#447999"
    }
}
