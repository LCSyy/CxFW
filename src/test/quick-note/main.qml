import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import MyItem 1.0

Window {
    visible: true
    width: 350
    height: 550
    title: qsTr("Hello World")
    // Component.onCompleted: showMaximized()

    QtObject {
        id: shapeInfo
        property var shapes: [
            {
                color: '#F096A0',
                size: 141.421356,
                vertices: [
                    Qt.point(0,0),
                    Qt.point(141.421356,0),
                    Qt.point(70.710679,70.710679)
                ]
            },
            {
                color: '#fff500',
                size: 100,
                vertices: [
                    Qt.point(0,0),
                    Qt.point(100,0),
                    Qt.point(100,100),
                    Qt.point(0,100)
                ]
            },
            {
                color: '#d22d2b',
                size: 141.421356,
                vertices: [
                    Qt.point(0,0),
                    Qt.point(141.421356,0),
                    Qt.point(141.421356,141.421356),
                    Qt.point(0,0),
                    Qt.point(141.421356,141.421356),
                    Qt.point(0,141.421356)
                ]
            },
            {
                color: '#e67817',
                size: 282.842712,
                vertices: [
                    Qt.point(0,0),
                    Qt.point(141.421356,141.421356),
                    Qt.point(0,282.842712)
                ]
            },
            {
                color: '#76c5f0',
                size: 282.842712,
                vertices: [
                    Qt.point(0,0),
                    Qt.point(141.421356,141.421356),
                    Qt.point(0,282.842712)
                ]
            },
            {
                color: '#6600a1',
                size: 141.421356,
                vertices: [
                    Qt.point(0,0),
                    Qt.point(141.421356,0),
                    Qt.point(70.710679,70.710679)
                ]
            },
            {
                color: '#00923f',
                size: 141.421356,
                vertices: [
                    Qt.point(0,0),
                    Qt.point(70.710678,70.710678),
                    Qt.point(70.710678,212.132034),
                    Qt.point(0,0),
                    Qt.point(70.710678,212.132034),
                    Qt.point(0,141.421356)
                ]
            }
        ]
    }

    Item {
        id: view
        width: parent.width
        height: parent.height * 0.85

        Rectangle {
            id: levelView
            anchors.top: parent.top
            anchors.topMargin: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.left: parent.left
            anchors.leftMargin: 2
            anchors.right: parent.right
            anchors.rightMargin: 2
            height: view.height * 0.9
            color: '#AAA'
            radius: 3

            ShapeItem {
                width: shapeInfo.shapes[2].size
                height: width
                anchors.centerIn: parent
                color: shapeInfo.shapes[2].color
                vertices: shapeInfo.shapes[2].vertices
            }
        }

        Row {
            width: parent.width
            anchors.top: levelView.bottom
            anchors.topMargin: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 2

            leftPadding: 2
            rightPadding: 2
            spacing: 10

            Button {
                height: parent.height
                width: height
                text: 'L'
            }
            Button {
                height: parent.height
                width: height
                text: 'R'
            }
            Button {
                height: parent.height
                width: height
                text: 'F'
            }
        }
    }

    ListView {
        id: shapes
        y: view.height
        orientation: Qt.Horizontal
        width: parent.width
        anchors.top: view.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        spacing: 6
        boundsBehavior: Flickable.StopAtBounds
        model: [
            '#F096A0',
            '#fff500',
            '#d22d2b',
            '#e67817',
            '#76c5f0',
            '#6600a1',
            '#00923f'
        ]
        delegate:  Rectangle {
            width: shapes.height
            height: shapes.height
            radius: 3
            border.color: modelData
        }
    }
}

// 141.421356
