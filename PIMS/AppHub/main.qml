import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import CxQuick 0.1

Item {
    Grid {
        anchors.fill: parent
        anchors.margins: 16
        columns: 4
        spacing: 16
        Button {
            text: qsTr("Click")
        }
        TextField {
        }
        ComboBox {
            model: [1,3,4,5,6,7]
        }
    }
}
