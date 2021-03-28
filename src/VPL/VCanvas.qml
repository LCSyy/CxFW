import QtQuick 2.15

Item {
    id: canvas

    required property Component edgeComponent
    required property Component nodeComponent

    property Item curNode: null
    property Item curEdge: null

    property int nodeCount: 0

    readonly property Item edgeInItem: dragEdgeInItem
    readonly property Item edgeOutItem: dragEdgeOutItem

    function addNode(title, color,inParams, outParams) {
        let node = nodeComponent.createObject(canvas,
                                              {
                                                  x: 100, y: 100,
                                                  nodeTitle: title,
                                                  nodeColor: color,
                                                  inParams: inParams,
                                                  outParams: outParams,
                                                  canvas: canvas,
                                              });
        canvas.curNode = node;
        nodeCount += 1;
    }

    function addEdge() {
        let edge = edgeComponent.createObject(canvas);
        canvas.curEdge = edge;
        return edge;
    }

    Item {
        id: dragEdgeInItem
        width: 16
        height: 16
        Drag.keys: ["edge_in"]
        Drag.hotSpot: Qt.point(8,8)

        property Item edge: null
    }

    Item {
        id: dragEdgeOutItem
        width: 16
        height: 16
        Drag.keys: ["edge_out"]
        Drag.hotSpot: Qt.point(8,8)

        property Item edge: null
    }
}
