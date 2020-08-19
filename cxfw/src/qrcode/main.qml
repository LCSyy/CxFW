import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import App 1.0

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")

    Button {
        onClicked: {
            const modules = QRGenerator.genQrCode();
            for(var i in modules) {
                console.log(modules[i]);
            }
        }
    }
}
