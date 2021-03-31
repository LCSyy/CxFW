import QtQuick 2.15

Item {
    id: canvasContainer

    function destroyUnconnectedEdge(edge) {
        let fromSlot = edge.from;
        if (fromSlot !== null) {
            let edges = fromSlot.edges;
            for (let i in edges) {
                let e = edges[i];
                if (e !== null && e === edge) {
                    edges.splice(i,1);
                    e.destroy();
                }
            }
        }
    }

    DropArea {
        anchors.fill: parent
        keys: ["slot_in", "slot_out"]
        onDropped: {
            if (drop.source && drop.source.edge !== null) {
                canvasContainer.destroyUnconnectedEdge(drop.source.edge);
            }
        }
    }
}
