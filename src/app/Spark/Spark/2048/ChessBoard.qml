import QtQuick 2.12

Rectangle {
    id: game2048
    width: 480
    height: width
    color: "#B7AAA1"
    radius: 6

    property int blockSize: (width - (blockMargin * 5)) / 4
    property int blockMargin: 12
    property color blockColor: "#894613"

    function posAt(row,col) {
        var block = repeater.itemAt(row*4+col);
        return repeater.mapToItem(game2048,block.x,block.y);
    }

    Grid {
        anchors.fill: parent
        anchors.margins:game2048.blockMargin
        spacing: game2048.blockMargin
        columns: 4
        Repeater {
            id: repeater
            model: 16
            delegate: Rectangle {
                width: game2048.blockSize
                height: game2048.blockSize
                radius: 6
                color: game2048.blockColor
            }
        }
    }
}
