import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

Item {
    id: loginPage

    signal clickLogin(string account, string passwd)

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12
        Grid {
            columns: 2
            spacing: 6
            verticalItemAlignment: Qt.AlignVCenter
            horizontalItemAlignment: Qt.AlignLeft

            Text {
                text: "Account"
            }

            TextField {
                id: accountField
            }

            Text {
                text: "Password"
            }

            TextField {
                id: passwdField
            }
        }

        Button {
            height: 30
            Layout.fillWidth: true
            text: "login"
            onClicked: {
                loginPage.clickLogin(accountField.text.trim(),passwdField.text.trim())
            }
        }
    }
}
