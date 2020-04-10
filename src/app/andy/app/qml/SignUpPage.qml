import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: signUpPage
    color: "#891346"

    signal signUp(string account, string passwd)

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
        TextField {
            id: confirm_passwd
            echoMode: TextField.Password
            placeholderText: 'confirm password'
        }
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 100
            height: 30
            text: "Sign Up"
            onClicked: {
                if(password.text === confirm_passwd.text) {
                    signUpPage.signUp(account.text,password.text)
                }
            }
        }
    }

}
