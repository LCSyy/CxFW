import QtQuick 2.15

Item {
    id: canvasContainer

    function destroyUnconnectedEdge(edge) {
        let outSlotItem = edge.outSlot;
        if (outSlotItem !== null) {
            let edges = outSlotItem.edges;
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
        keys: ["edge_out", "edge_in"]
        onDropped: {
            if (drop.source && drop.source.edge !== null) {
                canvasContainer.destroyUnconnectedEdge(drop.source.edge);
            }
        }
    }
}
