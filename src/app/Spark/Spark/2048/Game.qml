import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: game

    function randomIndex(exceptIndex) {
        const row = Math.floor(Math.random() * 3.9);
        const col = Math.floor(Math.random() * 3.9);
        return {"row":row,"column":col};
    }

    ChessBoard {
        id: chessBoard
        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent

            onPressed: {
            }
            onReleased: {
            }
        }
    }

    Button {
        text: "Start New Game"
        onClicked: {
            const m = game.randomIndex(-1);
            const pos = chessBoard.posAt(m.row,m.column);
            block.createObject(chessBoard,{"x":pos.x,"y":pos.y});
        }
    }

    Component {
        id: block

        Rectangle {
            width: chessBoard.blockSize
            height: chessBoard.blockSize
            radius: 6
            color: Qt.rgba(Math.random(),Math.random(),Math.random(),1.0)
        }
    }
}
