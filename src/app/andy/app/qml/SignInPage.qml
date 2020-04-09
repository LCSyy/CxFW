import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: loginPage
    anchors.fill: parent
    color: "#698474"

    signal login(string account, string passwd);

    function clearPassword() {
        password.text = "";
    }

    Column {
        spacing: 6
        anchors.centerIn: parent
        TextField {
            id: account
            placeholderText: 'account'
        }
        TextField {
            id: password
            echoMode: TextField.Password
            placeholderText: 'password'
        }
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 100
            height: 30
            text: "Login"
            onClicked: loginPage.login(account.text,password.text)
        }
    }

    Button {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 12
        width: 100
        height: 30
        text: "Sign Up"
    }
}
