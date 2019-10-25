import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Shapes 1.12

Page {
    anchors.fill: parent
    property string moduleName: ""

    RowLayout {
        anchors.fill: parent
        spacing:10
        ColumnLayout {
            Button { }
            TextField { selectByMouse: true }
        }
    }
}
