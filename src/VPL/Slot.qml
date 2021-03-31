import QtQuick 2.15

Item {
    id: slotItem
    width: 16
    height: 16

    required property VCanvas canvas
    required property Item node
    required property string dropKey

    enum SlotType {
        MultiIn,
        MultiOut,
        MultiBoth,
        SingleIn,
        SingleOut,
        SingleBoth
    }

    // property Item edge: null
    property var edges: []
    property int slotType: Slot.SlotType.MultiBoth

    function updateEdgePos() {
        console.log(edges)
        for (let e of edges) {
            console.log('update edge:', e)
            if (e !== null) {
                console.log('e:', e)
                e.updatePos();
            }
        }
    }

    function slotPos() {
        return slotRect.mapToItem(canvas, slotRect.width/2, slotRect.height/2);
    }

    function clearEdges() {
        for (let i = 0; i < edges.length; ) {
            let e = edges[i];
            console.log('len:',edges.length, 'i: ', i)
            if (e !== null && e.to !== slotItem) {
                if (e.to !== null) {
                    e.to.removeEdge(e);
                }
                edges.splice(i,1);
                e.destroy();
            } else if (e !== null && e.from !== slotItem) {
                if (e.from !== null) {
                    e.from.removeEdge(e);
                }
                edges.splice(i, 1);
                e.destroy();
            } else {
             ++i;
            }
        }
    }

    function clearInEdges() {
        for (let i = 0; i < edges.length; ) {
            let e = edges[i];
            if (e !== null && e.to !== slotItem) {
                e.to.removeEdge(e);
                edges.splice(i,1);
                e.destroy();
            } else {
             ++i;
            }
        }
    }

    function clearOutEdges() {
        for (let i = 0; i < edges.length; ) {
            let e = edges[i];
            if (e !== null && e.from !== slotItem) {
                e.from.removeEdge(e);
                edges.splice(i,1);
                e.destroy();
            } else {
             ++i;
            }
        }
    }

    function removeEdge(edge) {
        for (let i = 0; i < edges.length; ) {
            let e = edges[i];
            if (e !== null && e.from === slotItem || e.to === slotItem) {
                edges.splice(i,1);
                if (e.to === slotItem) {
                    e.to = null;
                }

                if (e.from === slotItem) {
                    e.from = null;
                }
            } else {
                ++i;
            }
        }
    }

    Rectangle {
        id: slotRect
        anchors.fill: parent
        radius: 8
        color: '#ABABAB'

        DropArea {
            anchors.fill: parent
            keys: [slotItem.dropKey]
            onEntered: {
                console.log('out edge entered')
            }

            onDropped: {
                console.log('out edge dropped')
                if (drop.source && drop.source.edge !== null) {
                    let edge = drop.source.edge;
                    if (edge !== null) {
                        edge.setTo(slotItem);
                    }
                    drop.source.x = 0;
                    drop.source.y = 0;
                }
            }
        }

        MouseArea {
            id: dragArea
            anchors.fill: parent
            onPressed: {
                mouse.accepted = true;
                let edge = canvas.addEdge()
                if (edge !== null) {
                    console.log('edge:', edge)
                    const p = slotItem.slotPos();
                    edge.startPoint = p;
                    edge.stopPoint = p;
                    edge.setFrom(slotItem);
                    if (slotItem.dropKey === "slot_in") {
                        canvas.slotOutItem.edge = edge;
                        drag.target = canvas.slotOutItem;
                    } else if (slotItem.dropKey === "slot_out") {
                        canvas.slotInItem.edge = edge;
                        drag.target = canvas.slotInItem;
                    }
                }
            }
            onPositionChanged: {
                mouse.accepted = true;
                if (canvas.curEdge !== null) {
                    const p = dragArea.mapToItem(canvas, mouse.x, mouse.y);
                    canvas.curEdge.stopPoint = p;
                    if (slotItem.dropKey === "slot_in") {
                        canvas.slotOutItem.x = p.x - canvas.slotOutItem.width / 2;
                        canvas.slotOutItem.y = p.y - canvas.slotOutItem.height / 2;
                    } else if (slotItem.dropKey === "slot_out") {
                        canvas.slotInItem.x = p.x - canvas.slotInItem.width / 2;
                        canvas.slotInItem.y = p.y - canvas.slotInItem.height / 2;
                    }
                }
            }
            onReleased: {
                mouse.accepted = true
                if (slotItem.dropKey === "slot_in") {
                    canvas.slotOutItem.Drag.active = true;
                    canvas.slotOutItem.Drag.drop();
                    canvas.slotOutItem.Drag.active = false;
                } else if (slotItem.dropKey === "slot_out") {
                    canvas.slotInItem.Drag.active = true;
                    canvas.slotInItem.Drag.drop();
                    canvas.slotInItem.Drag.active = false;
                }
            }
        }
    }

    Component {
        id: edgeComponent
        Edge {}
    }
}
