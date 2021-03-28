import QtQuick 2.15
import QtQuick.Controls 2.15
import Universe 0.1
import "../qml/BoxTheme.js" as BoxTheme
import "../qml/AppConfigs.js" as Config

Item {
    id: page
    signal login(bool ok)

    Component.onCompleted: {
        Sys.setData("login", false)

        CxNetwork.del(URLs.service("login").url(""), Config.basicAuth(), (resp)=>{
                          // ...
                      })
    }

    Column {
        spacing: BoxTheme.spacing * 2
        anchors.centerIn: parent
        Column {
            spacing: 0
            Text { text: qsTr("User name") }
            TextField { id: username }
        }

        Column {
            spacing: 0
            Text { text: qsTr("Password") }
            TextField { id: password; echoMode: TextField.Password }
        }

        Button {
            width: parent.width
            text: qsTr("Login")
            onClicked: {
                const user = {
                    id: 0,
                    account: username.text.trim(),
                    password: password.text.trim(),
                };
                CxNetwork.post(URLs.service("login").url(""), Config.basicAuth(), user, (resp)=>{
                                   try {
                                       const reply = JSON.parse(resp);
                                       const body = reply.body;
                                       if (reply.err === null && ((body || null) !== null)) {
                                           Sys.setData("login", true)
                                           page.login(true)
                                       }
                                   } catch(e) {
                                       console.log(e.toString());
                                   }
                                   page.login(false)
                              })
            }
        }
    }
}
