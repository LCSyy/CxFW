import QtQuick 2.15

Item {
    id: slotItem
    width: 16
    height: 16

    required property VCanvas canvas
    required property Item node

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
    property int slotType: 0

    function updateEdgePos() {
        for (let e of edges) {
            if (e !== null) {
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
            if (e !== null && e.to !== slotItem) {
                e.to.removeEdge(e);
                edges.splice(i,1);
                e.destroy();
            } else if (e !== null && e.from !== slotItem) {
                e.from.removeEdge(e);
                edges.splice(i, 1);
                e.destroy();
            } else  {
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
        for (let i = 0; i < edges.length; ++i) {
            let e = edges[i];
            if (e !== null && e.from === slotItem || e.to === slotItem) {
                edges.splice(i,1);
                if (e.to === slotItem) {
                    e.to = null;
                }

                if (e.from === slotItem) {
                    e.from = null;
                }
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
            keys: ['edge_out', 'edge_in']
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

    Component {
        id: edgeComponent
        Edge {}
    }
}
