import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

import CxFw.CxStyle 0.1
import CxFw.CxQuick 0.1
import VPL 0.1

ApplicationWindow {
    id: app
    width: 960
    height: 720
    visible: true
    title: qsTr("Hello World")
//    color: "#727272"

    function nodeColorInfo(inCount, outCount) {
        if (inCount === 0 && outCount === 0) {
            return 'red'; // error
        }

        if (inCount === 0) {
            return '#5dbe8a'; // no input, only output
        }

        if (outCount === 0) {
            return '#fed71a'; // no output, only input
        }

        return '#11aaDE'; // normal function
    }

    menuBar: MenuBar {
        Menu {
            title: "File(&F)"
            MenuItem {
                text: "Open"
            }
            MenuItem {
                text: "New"
            }
        }

        Menu {
            title: "Edit(&E)"
            MenuItem {
                text: "Undo"
            }
            MenuItem {
                text: "Redo"
            }
        }
    }

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: CxStyle.margins
            anchors.rightMargin: CxStyle.margins
            Button {
                text: qsTr("New Node")
                Layout.alignment: Qt.AlignVCenter
                onClicked: {
                    addNodePopup.open()
                }
            }

            Button {
                text: qsTr("Back to origin")
                Layout.alignment: Qt.AlignVCenter
                onClicked: {
                    canvas.x = 0
                    canvas.y = 0
                }
            }
            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }

    footer: ToolBar {
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: CxStyle.margins
            anchors.rightMargin: CxStyle.margins

            Text {
                 text: "Node count: " + canvas.nodeCount
            }

            Text {
                 text: "Scale: {0}%".replace('{0}', canvas.scale * 100)
            }

            Item {
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }
    }

    Shortcut {
        sequence: Qt.Key_Delete
        onActivated: {
            if (canvas.curNode !== null) {
                canvas.curNode.removeSelf();
            }
        }
    }

    SplitView {
        anchors.fill: parent
        Item {
            SplitView.minimumWidth: 300
            SplitView.fillHeight: true

            Column {
                Repeater {
                    id: whatFuck
                    delegate: Text {
                        text: modelData.name
                    }
                }
            }
        }

        CanvasContainer {
            SplitView.fillWidth: true
            SplitView.fillHeight: true
            clip: true

            MouseArea {
                id: canvasArea
                anchors.fill: parent
                drag.target: canvas
                onClicked: {
                    canvas.curEdge = null
                    canvas.curNode = null
                }

                onWheel: {
                    wheel.accepted = false;
                    if (wheel.angleDelta.y > 0) {
                        const minScale = (canvas.scale * 1.1).toPrecision(2);
                        canvas.scale = minScale < 3 ? minScale : 3;
                    } else if (wheel.angleDelta.y < 0) {
                        const minScale = (canvas.scale / 1.1).toPrecision(2);
                        canvas.scale = minScale > 0.1 ? minScale : 0.1;
                    }
                }
            }

            VCanvas {
                id: canvas
                Drag.active: canvasArea.drag.active

                edgeComponent: iEdgeComponent
                nodeComponent: iNodeComponent
            }
        }
    }

    Component {
        id: iEdgeComponent
        Edge { }
    }

    Component {
        id: iNodeComponent
        Node { }
    }

    Popup {
        id: addNodePopup
        modal: true
        focus: true
        anchors.centerIn: app.contentItem

        implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                                implicitContentWidth + leftPadding + rightPadding)
        implicitHeight: Math.max(implicitBackgroundHeight + topInset + rightInset,
                                 implicitContentHeight + topPadding + bottomPadding)

        contentItem: Page {
            implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                                    implicitContentWidth + leftPadding + rightPadding)
            implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                     implicitContentHeight + topPadding + bottomPadding)

            header: ToolBar {
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: CxStyle.margins
                    anchors.rightMargin: CxStyle.margins
                    Button {
                        text: qsTr("Ok")
                        onClicked: {
                            let inParams = [];
                            const outParams = [];

                            for (let i = 0; i < inSlotParamModel.count(); ++i) {
                                const item = inSlotParamModel.get(i);
                                inParams.push(item);
                            }

                            for (let j = 0; j < outSlotParamModel.count(); ++j) {
                                const item = outSlotParamModel.get(j);
                                outParams.push(item);
                            }

                            canvas.addNode(titleField.text.trim(),
                                           app.nodeColorInfo(inParams.length, outParams.length),
                                           inParams,
                                           outParams);
                            addNodePopup.close();
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    Button {
                        text: qsTr("Cancel")
                        onClicked: addNodePopup.close()
                    }
                }
            }

            background: Rectangle {
                implicitWidth: 600
                implicitHeight: 600
            }

            contentItem: ColumnLayout  {
                implicitWidth: 600
                implicitHeight: 600

                Label { text: "Node name" }
                TextField {
                    Layout.fillWidth: true;
                    id: titleField; placeholderText: "Node name"
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Label { text: "Input params" }
                        ListView {
                            id: inSlotParamView
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true

                            model: CxListModel {
                                id: inSlotParamModel
                                roleNames: ["name"]
                            }

                            delegate: Row {
                                width: inSlotParamView.width
                                height: 40
                                    TextField{
                                        placeholderText: qsTr("param name")
                                        onTextChanged: {
                                            const i = model.index;
                                            inSlotParamModel.set(i,'name', text.trim());
                                        }
                                    }
                                }

                            footer: ToolBar {
                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 8
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 8
                                    Button {
                                        Layout.fillWidth: true
                                        text: qsTr("+")
                                        font.pointSize: Qt.application.font.pointSize + 4
                                        font.bold: true
                                        onClicked: {
                                            inSlotParamModel.append({name:''});
                                        }
                                    }
                                    Button {
                                        Layout.fillWidth: true
                                        text: qsTr("-")
                                        font.pointSize: Qt.application.font.pointSize + 4
                                        font.bold: true
                                        onClicked: {
                                            const c = inSlotParamModel.count();
                                            if (c > 0) {
                                                inSlotParamModel.remove(c-1);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Label { text: "Output params" }
                        ListView {
                            id: outSlotParamView
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true

                            model: CxListModel {
                                id: outSlotParamModel
                                roleNames: ["name"]
                            }

                            delegate: Row {
                                width: outSlotParamView.width
                                height: 40
                                TextField{
                                    placeholderText: qsTr("param name");
                                    onTextChanged: {
                                        const i = model.index;
                                        outSlotParamModel.set(i,'name', text.trim());
                                    }
                                }
                            }

                            footer: ToolBar {
                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 8
                                    anchors.leftMargin: 8
                                    anchors.rightMargin: 8
                                    Button {
                                        Layout.fillWidth: true
                                        text: qsTr("+")
                                        font.pointSize: Qt.application.font.pointSize + 4
                                        font.bold: true
                                        onClicked: {
                                            outSlotParamModel.append({name:''});
                                        }
                                    }
                                    Button {
                                        Layout.fillWidth: true
                                        text: qsTr("-")
                                        font.pointSize: Qt.application.font.pointSize + 4
                                        font.bold: true
                                        onClicked: {
                                            const c = outSlotParamModel.count();
                                            if (c > 0) {
                                                outSlotParamModel.remove(c-1);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
