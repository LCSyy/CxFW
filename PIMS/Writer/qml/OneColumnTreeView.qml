import QtQuick 2.15
import QtQml.Models 2.15
import CxQuick 0.1 as Cx

ListView {
    id: listView

    function mouseClickMapToListViewIndex(mouseArea, mouse) {
        const p = mouseArea.mapToItem(this,mouse.x,mouse.y);
        const idx = this.indexAt(p.x+this.contentX, p.y+this.contentY);
        return idx;
    }

    function load(treeItems) {
        treeModel.clear();
        // treeModel.append({id: -1, title: "所有", created_at: "", parent: -1, expand: false, visible: true, level: 0, hasChildren: false });
        treeModel.loadTree(treeItems, -1, 0)
    }

    QtObject {
        id: theme
        readonly property color highlightColor: "gray"
        readonly property int rowHeight: 25
        readonly property int arrowSize: 10
        readonly property color arrowColor: Cx.Theme.bgNormalColor
        readonly property int arrowTextSpacing: 8
        readonly property int arrowLeftMargin: 8
    }

    model: Cx.ListModel {
        id: treeModel
        roleNames: ["id","title","created_at", "parent", "expand", "visible", "level","hasChildren"]

        function loadTree(items, parentID, level) {
            if ((items || null) === null) { return; }

            for (var i = 0; items.length > 0 && i < items.length; ) {
                const item = items[i];
                if (item.parent === parentID) {
                    items.splice(i,1);
                    const cur = {
                        id: item.id,
                        title: item.title,
                        created_at: item.created_at,
                        parent: item.parent,
                        expand: false,
                        visible: parentID === -1 ? true : false,
                        level: level,
                        hasChildren: false,
                    }
                    treeModel.append(cur);
                    const idx = treeModel.count() - 1;
                    const oldCount = items.length;
                    items = loadTree(items, item.id, level+1);
                    if (oldCount > items.length) {
                        treeModel.set(idx,"hasChildren", true);
                    }
                    i = 0;
                } else {
                    i += 1;
                }
            }

            return items;
        }
    }

    delegate: Item {
        width: parent === null ? 0 : parent.width
        height: model.visible ? theme.rowHeight : 0
        visible: model.visible

        function execClick(p) {
            const pp = mapToItem(arrow,p.x,p.y)
            if (arrow.contains(pp) && model.hasChildren) {
                const expand = !model.expand;
                treeModel.set(model.index,"expand",expand);
                var pIdxs = [];
                pIdxs.push({id: model.id, visible: expand});
                while(pIdxs.length > 0) {
                    const pm = pIdxs.splice(0,1)[0];
                    for (var j = 0; j < treeModel.count(); ++j) {
                        const m = treeModel.get(j);
                        if (m.parent === pm.id) {
                            treeModel.set(j,"visible", pm.visible);
                            pIdxs.push({id: m.id, visible: (pm.visible ? m.expand : pm.visible)});
                        }
                    }
                }
                arrow.markDirty(Qt.rect(0,0,theme.arrowSize,theme.arrowSize))
                return true
            }
            return false
        }

        Row {
            anchors.fill: parent
            anchors.leftMargin: theme.arrowLeftMargin + (theme.arrowSize + theme.arrowTextSpacing) * model.level
            Item {
                width: theme.arrowSize
                height: parent === null ? 0 : parent.height

                Canvas {
                    id: arrow
                    anchors.centerIn: parent
                    width: theme.arrowSize
                    height: theme.arrowSize
                    visible: model.hasChildren

                    onPaint: {
                        const s = theme.arrowSize
                        var c = getContext("2d")
                        c.clearRect(0,0,s,s)
                        c.beginPath()
                        c.fillStyle = "#00000000"
                        c.fillRect(0,0, s, s)
                        c.closePath()
                        c.beginPath()
                        c.fillStyle = theme.arrowColor
                        if (model.expand) {
                            c.moveTo(0,0)
                            c.lineTo(s,0)
                            c.lineTo(s/2,s)
                        } else {
                            c.moveTo(0,0)
                            c.lineTo(s,s/2)
                            c.lineTo(0,s)
                        }
                        c.closePath()
                        c.fill()
                    }
                }
            }

            Text {
                leftPadding: theme.arrowTextSpacing
                text: model.title
                height: parent === null ? 0 : parent.height
                verticalAlignment: Qt.AlignVCenter
            }
        }
    }

    highlightMoveDuration: 1
    highlight: Rectangle {
        width: parent !== null ? parent.width : 0
        height: theme.rowHeight
        color: theme.highlightColor
    }
}
