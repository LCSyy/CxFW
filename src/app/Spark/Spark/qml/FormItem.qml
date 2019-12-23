import QtQuick 2.12

Item {
    id: control
    property string text

    Text {
        id: label
        objectName: "_label_"
        text: control.text
        anchors.verticalCenter: control.verticalCenter
    }

    Component.onCompleted: {
        const w = label.width + 10;
        if(parent.parent.labelWidth < w) {
            parent.parent.labelWidth = w;
        }
    }

    function updateLabelWidth() {
        for(const i in children) {
            var item = children[i];
            if(item.objectName !== "_label_") {
                control.implicitWidth = parent.width;
                control.implicitHeight = Math.max(label.height, item.height);
                item.width = parent. parent.width - parent.parent.labelWidth;
                item.anchors.verticalCenter = control.verticalCenter;
                item.anchors.left = label.right;
                item.anchors.leftMargin = parent.parent.labelWidth - label.width;
            }
        }
    }
}
