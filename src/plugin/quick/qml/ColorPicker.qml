import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12

Pane {
    id: _colorPicker
    width: _detailColor.width + _colorCanvas.width + 3 * 12
    height: _handler.height + _detailColor.height + _previewColorRect.height + 3 * 12

    topPadding: 34
    property alias curClor: _curColorRect.color

    background: Pane {
        topPadding: 0

        Material.background: '#424242'
        Material.elevation: 12

        Control {
            id: _handler
            width: parent.width
            height: 23
            contentItem: RowLayout {
                Text {
                    text: '='
                    color: 'white'
                }
                Text {
                    Layout.fillWidth: true
                    text: 'Color Picker'
                    color: 'white'
                }
                Text {
                    text: '-'
                    color: 'white'
                }
            }
        }
        Rectangle {
            width: parent.width
            height: 1
            anchors.top: _handler.bottom
            color: '#303030'
        }
    }

    Canvas {
        id: _detailColor
        anchors.left: parent.left
        anchors.top: parent.top
        width: 200
        height: 200

        property bool grabColor: false
        property rect pickRect: Qt.rect(0,0,1,1)
        property color startColor: Qt.rgba(0.5,0.5,0.5,1)

        onPaint: {
            // 底色填充，也就是（举例红色）到白色
            var ctx = getContext('2d')
            var gradientBase = ctx.createLinearGradient(0, 0, width, 0);
            gradientBase.addColorStop(1, startColor);
            gradientBase.addColorStop(0, Qt.rgba(1,1,1,1));
            ctx.fillStyle = gradientBase;
            ctx.fillRect(0, 0, width, height);

            // 第二次填充，黑色到透明
            var my_gradient1 = ctx.createLinearGradient(0, 0, 0, height);
            my_gradient1.addColorStop(0, Qt.rgba(0,0,0,0));
            my_gradient1.addColorStop(1, Qt.rgba(0,0,0,1));
            ctx.fillStyle = my_gradient1;
            ctx.fillRect(0, 0, width, height);
            if(grabColor) {
                var imgData = ctx.getImageData(pickRect.x,pickRect.y,pickRect.width, pickRect.height)
                if(imgData !== undefined)
                    _previewColorRect.color = Qt.rgba(imgData.data[0]/255,imgData.data[1]/255,imgData.data[2]/255,imgData.data[3]/255)
                grabColor = false
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                _detailColor.grabColor = true
                _detailColor.pickRect = Qt.rect(mouse.x, mouse.y,1,1)
                _detailColor.requestPaint()
            }
        }
    }

    Canvas {
        id: _colorCanvas
        anchors.left: _detailColor.right
        anchors.leftMargin: 12
        anchors.top: parent.top
        width: 30
        height: _detailColor.height

        property bool grabColor: false
        property rect pickRect: Qt.rect(0,0,1,1)

        onPaint: {
            // 底色填充，也就是（举例红色）到白色
            var ctx = getContext('2d')
            var gradientBase = ctx.createLinearGradient(0, 0, 0, height);
            gradientBase.addColorStop(0, 'red');
            gradientBase.addColorStop(0.33, 'green');
            gradientBase.addColorStop(0.66, 'blue');
            gradientBase.addColorStop(1, 'red');
            ctx.fillStyle = gradientBase;
            ctx.fillRect(0, 0, width, height);

            if(grabColor) {
                var imgData = ctx.getImageData(pickRect.x,pickRect.y,pickRect.width, pickRect.height)
                if(imgData !== undefined) {
                    _detailColor.startColor = Qt.rgba(imgData.data[0]/255,imgData.data[1]/255,imgData.data[2]/255,imgData.data[3]/255)
                    _detailColor.requestPaint()
                }
                grabColor = false
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                _colorCanvas.grabColor = true
                _colorCanvas.pickRect = Qt.rect(mouse.x, mouse.y,1,1)
                _colorCanvas.requestPaint()
            }
        }
    }

    Rectangle {
        id: _previewColorRect
        anchors.top: _detailColor.bottom
        anchors.topMargin: 12
        anchors.left: parent.left
        width: 82
        height: 30
        color: 'black'
    }
    Rectangle {
        id: _curColorRect
        anchors.top: _detailColor.bottom
        anchors.topMargin: 12
        anchors.left: _previewColorRect.right
        width: 82
        height: 30
        color: 'black'
    }

    Button {
        anchors.left: _curColorRect.right
        anchors.top: _detailColor.bottom
        anchors.topMargin: 6
        anchors.leftMargin: 12
        onClicked: {
            _curColorRect.color = _previewColorRect.color
        }
    }
}
