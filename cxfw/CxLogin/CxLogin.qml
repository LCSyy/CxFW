import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    id: control

    signal login(string account, string pass)

    Label {
        Layout.alignment: Qt.AlignLeft
        font.bold: true
        font.pointSize: 12
        text: qsTr("Account")
    }
    TextField {
        id: account
        Layout.fillWidth: true
        placeholderText: qsTr("Phone number | Email")
    }
    Label {
        Layout.alignment: Qt.AlignLeft
        font.bold: true
        font.pointSize: 12
        text: qsTr("Password")
    }
    TextField {
        id: passwd
        Layout.fillWidth: true
        placeholderText: qsTr("Password, at least 8")
    }
    Button {
        Layout.fillWidth: true
        text: qsTr("Login")
        onClicked: control.login(account.text.trim(),passwd.text.trim())
    }
}
