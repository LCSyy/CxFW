import QtQuick 2.15
import QtQuick.Controls 2.15
import CxQuick 0.1 as Cx

Item {

    Component.onCompleted: {
        Cx.Network.enableHttps();
    }

    QtObject {
        id: types
        readonly property color mask: "#894689"
        readonly property color unmask: "#000"
    }

    Column {
        anchors.centerIn: parent

        Text {
            id: msgText
        }

        Button {
            onClicked: {
                mask.showMask(true);
                Cx.Network.get("https://192.168.1.6:8100/api/posts/1",{},(resp)=>{
                    try{
                                       console.log("try 1 try");
                        const body = JSON.parse(resp).body;
                        msgText.text = body.content;
                                       console.log(JSON.stringify(body));
                    }catch(e){
                         console.log(JSON.stringify(e));
                    }
                    mask.showMask(false);
                })
            }
        }
    }

    Rectangle {
        id: mask
        anchors.fill: parent
        visible: false

        function showMask(s) {
            if (s === true) {
                color = types.mask;
                visible = true;
            } else {
                color = types.unmask;
                visible = false;
            }
        }
    }
}
