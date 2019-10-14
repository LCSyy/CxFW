import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12


Item {

    property alias addItem : _container.addItem;

    /*
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
    */

    Container {
        id: _container
    }
}
