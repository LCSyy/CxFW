import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QuickBoard 1.0

Page {
    anchors.fill: parent

    property string moduleName: ""

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: "Next"
                onClicked: {
                    if(_container.currentIndex === _container.count - 1) {
                        _container.currentIndex = 0;
                    } else {
                        _container.currentIndex += 1;
                    }

                    const itemCount = _loader.children.length;
                    for(var idx = 0; idx < itemCount; ++idx) {
                        _loader.children[idx].parent = _container
                    }
                    _container.currentItem.parent = _loader
                }
            }
        }
    }

    Item {
        id: _loader
        anchors.fill: parent
    }

    Container {
        id: _container

        Rectangle {
            width: 100
            height: 100
            color: "red"
        }
        Rectangle {
            width: 100
            height: 100
            color: "green"
        }
        Rectangle {
            width: 100
            height: 100
            color: "blue"
        }
    }

}
