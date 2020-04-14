import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: game

    property list<Item> blocks

    function randomIndex(exceptIndex) {
        const row = Math.floor(Math.random() * 3.9);
        const col = Math.floor(Math.random() * 3.9);
        return {"row":row,"column":col};
    }

    // 0:Left, 1:Right, 2: Up, 3: Down
    readonly property var direction: Object({left:0,right:1,up:2,down:3})

    function moveDirection(dx,dy) {
       var direct = undefined;
       if (Math.abs(dx) >= Math.abs(dy)) {
           direct = (dx <= 0) ? direction.left : direction.right;
       } else {
           direct = (dy <= 0) ? direction.up : direction.down;
       }
       return direct;
    }

    function moveBlocks(direct) {
        for(var i = 0; i < blocks.length; ++i) {
            var item = blocks[i];
            var row = item.row;
            var col = item.column;
            if (direct === direction.left) { col = 0; }
            else if (direct === direction.right) { col = 3; }
            else if (direct === direction.up) { row = 0; }
            else if (direct === direction.down) { row = 3; }

            const pos = chessBoard.posAt(row,col);
            item.x = pos.x;
            item.y = pos.y;
            item.column = col;
            item.row = row;
        }
    }

    ChessBoard {
        id: chessBoard
        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent
            property point startPoint

            onPressed: {
                startPoint = Qt.point(mouse.x,mouse.y)
            }

            onReleased: {
                const dx = mouse.x - startPoint.x;
                const dy = mouse.y - startPoint.y;
                const motionLen = Math.sqrt(Math.pow(dx,2) + Math.pow(dy,2));
                if (motionLen > 20) {
                    const direction = game.moveDirection(dx,dy);
                    game.moveBlocks(direction);
                }
            }
        }
    }

    Button {
        text: "Start New Game"
        onClicked: {
            const m = game.randomIndex(-1);
            const pos = chessBoard.posAt(m.row,m.column);
            var item = block.createObject(chessBoard,{"x":pos.x,"y":pos.y,"row":m.row,"column":m.column});
            game.blocks.push(item)
        }
    }

    Component {
        id: block

        Rectangle {
            property int row: -1
            property int column: -1
            width: chessBoard.blockSize
            height: chessBoard.blockSize
            radius: 6
            color: Qt.rgba(Math.random(),Math.random(),Math.random(),1.0)
        }
    }
}
