import QtQuick 2.15
import VPL 0.1

EdgeItem {
    id: edgeItem
    z: 1
    color: "#568979"

    enum ConnectionType {
        Oriented,
        Undirected
    }

    property int type: Edge.ConnectionType.Oriented
    property Item from: null
    property Item to: null

    function updatePos() {
        if (from !== null) {
            startPoint = from.slotPos();
        }
        if (to != null) {
            stopPoint = to.slotPos();
        }
    }

    function unset() {
        if (from !== null) {
            from.removeEdge(edgeItem);
        }

        if (to !== null) {
            to.removeEdge(edgeItem);
        }

        edgeItem.destroy();
    }

    function setFrom(slot) {
        console.log('setFrom', slot.node)
        if (to !== null) {
            if (to.node === slot.node) {
                unset();
                return;
            }
        }

        console.log('from slot type:',slot.slotType)
        if (slot.slotType === Slot.SlotType.SingleIn || slot.slotType === Slot.SlotType.SingleOut) {
            slot.clearEdges();
        }

        if (slot.slotType === Slot.SlotType.SingleBoth) {
            slot.clearInEdges();
        }

        edgeItem.from = slot;
        slot.edges.push(edgeItem);
        updatePos();
    }

    function setTo(slot) {
        console.log('setTo', slot.node)
        if (from !== null && from.node === slot.node) {
            unset();
            return;
        }

        console.log('to slot type:',slot.slotType)
        if (slot.slotType === Slot.SlotType.SingleIn || slot.slotType === Slot.SlotType.SingleOut) {
            slot.clearEdges();
        }

        if (slot.slotType === Slot.SlotType.SingleBoth) {
            slot.clearOutEdges();
        }

        edgeItem.to = slot;
        slot.edges.push(edgeItem);
        updatePos();
    }
}
