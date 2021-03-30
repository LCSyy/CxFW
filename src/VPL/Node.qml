import QtQuick 2.15

Rectangle {
    id: nodeItem
    width: nodeColumn.width + 4
    height: nodeColumn.height + 4
    z: dragArea.drag.active ? 2 : 0
    Drag.active: dragArea.drag.active
    border.width: 2
    border.color: canvas.curNode === nodeItem ? "#fed71a" : "black"

    required property VCanvas canvas

    property alias nodeTitle: nodeText.text
    property alias nodeColor: titleRect.color
    property var inParams: []
    property var outParams: []

    function removeSelf() {
        // ...
    }

    MouseArea {
        id: dragArea
        anchors.fill: parent
        drag.target: nodeItem
        onPressed: {
            mouse.accepted = true;
            canvas.curNode = nodeItem;
        }

        onPositionChanged: {
            mouse.accepted = true;
            for (var n in inSlotColumn.children) {
                var slot = inSlotColumn.children[n];
                if (slot !== null && slot.updateEdgePos !== undefined) {
                    slot.updateEdgePos();
                }
            }

            for (n in outSlotColumn.children) {
                slot = outSlotColumn.children[n];
                if (slot !== null && slot.updateEdgePos !== undefined) {
                    slot.updateEdgePos();
                }
            }
        }

        onReleased: mouse.accepted = true
    }

    Column {
        id: nodeColumn
        x: 2
        y: 2

        Rectangle {
            id: titleRect
            width: Math.max(nodeColumn.width, nodeText.contentWidth + 32)
            height: Math.max(40, nodeText.height)
            color: "#ABCDAE"

            Text {
                id: nodeText
                font.pointSize: Qt.application.font.pointize + 4
                font.bold: true
                anchors.fill: parent
                anchors.leftMargin: 4
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignLeft
            }

        }

        Rectangle {
            id: slotRect
            color: "#525252"
            width: Math.max(nodeColumn.width, inSlotColumn.width + outSlotColumn.width + 16)
            height: Math.max(inSlotColumn.height, outSlotColumn.height)

            Column {
                id: inSlotColumn
                anchors.left: parent.left
                spacing: 8
                topPadding: 8
                bottomPadding: 8
                Repeater {
                    id: repeater
                    model: nodeItem.inParams
                    delegate: Slot {
                        slotType: Slot.SlotType.SingleIn
                        canvas: nodeItem.canvas
                        node: nodeItem
                    }
                }
            }

            Column {
                id: outSlotColumn
                anchors.right: parent.right
                spacing: 8
                topPadding: 8
                bottomPadding: 8
                Repeater {
                    model: nodeItem.outParams
                    delegate: Slot {
                        slotType: Slot.SlotType.MultiOut
                        canvas: nodeItem.canvas
                        node: nodeItem
                    }
                }
            }
        }
    }

    /*
    Component {
        id: inSlotComponent

        Item {
            id: inSlotItem
            width: slotRect.width + slotText.contentWidth + spacing
            height: Math.max(slotRect.height, slotText.contentHeight + spacing)
            readonly property int spacing: 4

            property Item edge: null

            function  updateEdgePos() {
                if (edge !== null) {
                    edge.stopPoint = slotPos();
                }
            }

            function slotPos() {
                return slotRect.mapToItem(canvas, slotRect.x + slotRect.width / 2, slotRect.y + slotRect.height / 2);
            }

            Rectangle {
                id: slotRect
                width: 16
                height: 16
                radius: 8
                color: '#ABABAB'

                DropArea {
                    anchors.fill: parent
                    keys: ['edge_out']
                    onEntered: {
                        console.log('out edge entered')
                    }

                    onDropped: {
                        console.log('out edge dropped')
                        if (drop.source && drop.source.edge !== null) {
                            let edge = drop.source.edge;
                            if (inSlotItem.edge !== null) {
                                let outSlotItem = inSlotItem.edge.outSlot;
                                if (outSlotItem !== null) {
                                    let edges = outSlotItem.edges;
                                    for (let i in edges) {
                                        let e = edges[i];
                                        if (e !== null && e === inSlotItem.edge) {
                                            edges.splice(i,1);
                                            e.destroy();
                                            inSlotItem.edge = null;
                                        }
                                    }
                                }
                            }

                            edge.connected = true;
                            edge.inSlot = inSlotItem;
                            edge.stopPoint = inSlotItem.slotPos();
                            inSlotItem.edge = edge;
                            drop.source.x = 0;
                            drop.source.y = 0;
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: mouse.accepted = true
                    onPositionChanged: mouse.accpeted = true
                    onReleased: mouse.accepted = true
                }
            }

            Text {
                x: slotRect.width + parent.spacing
                id: slotText
                text: modelData.name
                color: "white"
                font.bold: true
                font.pointSize: Qt.application.font.pointSize + 2
            }
        }

    }

    Component {
        id: outSlotComponent

        Item {
            id: outSlotItem
            width: Math.max(parent.width, slotRect.width + slotText.contentWidth + spacing)
            height: Math.max(slotRect.height, slotText.contentHeight + spacing)
            readonly property int spacing: 4

            property var edges: []

            function updateEdgePos() {
                for (let e of edges) {
                    if (e !== null && e.inSlot !== null && e.outSlot !== null) {
                         e.startPoint = e.outSlot.slotPos();
                    }
                }
            }

            function slotPos() {
                return slotRect.mapToItem(canvas, slotRect.width/2, slotRect.height/2);
            }

            Text {
                id: slotText
                anchors.right: slotRect.left
                anchors.rightMargin: outSlotItem.spacing
                text: modelData.name
                color: "white"
                font.bold: true
                font.pointSize: Qt.application.font.pointSize + 2
            }

            Rectangle {
                id: slotRect
                anchors.right: parent.right
                width: 16
                height: 16
                radius: 8
                color: '#ABABAB'

                DropArea {
                    anchors.fill: parent
                    keys: ["edge_in"]
                    onEntered: {
                        console.log('entered')
                    }
                    onDropped: {
                        console.log('dropped')
                    }
                }

                MouseArea {
                    id: dragArea
                    anchors.fill: parent
                    onPressed: {
                        mouse.accepted = true;
                        let edge = canvas.addEdge();
                        if (edge !== null) {
                            console.log('edge:', edge)
                            const p = outSlotItem.slotPos();
                            edge.startPoint = p;
                            edge.stopPoint = p;
                            edge.outSlot = outSlotItem
                            outSlotItem.edges.push(edge);
                            canvas.edgeOutItem.edge = edge;
                            drag.target = canvas.edgeOutItem;
                        }
                    }
                    onPositionChanged: {
                        mouse.accepted = true;
                        if (canvas.curEdge !== null) {
                            const p = dragArea.mapToItem(canvas, mouse.x, mouse.y);
                            canvas.curEdge.stopPoint = p;
                            canvas.edgeOutItem.x = p.x - canvas.edgeOutItem.width / 2;
                            canvas.edgeOutItem.y = p.y - canvas.edgeOutItem.height / 2;
                        }
                    }
                    onReleased: {
                        mouse.accepted = true
                        canvas.edgeOutItem.Drag.active = true;
                        canvas.edgeOutItem.Drag.drop();
                        canvas.edgeOutItem.Drag.active = false;
                    }
                }
            }
        }
    }
    */
}
