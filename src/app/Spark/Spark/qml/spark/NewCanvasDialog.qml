import QtQuick 2.12
import QtQuick.Controls 2.12

import Spark 1.0 as Spark
import ".." as SparkQuick

Dialog {
    id: newSettingPopup
    anchors.centerIn: parent
    dim: true
    closePolicy: Popup.NoAutoClose
    margins: 20
    width: 400
    height: 450
    title: qsTr("New Canvas")

    SparkQuick.FormLayout {
        anchors.fill: parent
        SparkQuick.FormItem {
            text: qsTr("File Name")
            TextField {
                id: fileNameField
                placeholderText: qsTr("file name")
            }
        }

        SparkQuick.FormItem {
            text: qsTr("Canvas Width")
            TextField {
                id: widthField
                validator: IntValidator{ bottom:0 }
            }
        }

        SparkQuick.FormItem {
            text: qsTr("Canvas Height")
            TextField {
                id: heightField
                validator: IntValidator{ bottom:0 }
            }
        }
    }

    function setData(data) {
        console.log(data);
        if(data === undefined || data === null) {
            fileNameField.text = "";
            widthField.text = "";
            heightField.text = "";
        }
    }

    function getData() {
        return {
            fileName: fileNameField.text,
            canvas: {
                width: parseInt(widthField.text),
                height: parseInt(heightField.text)
            }
        };
    }

    footer: Row {
        layoutDirection: Qt.RightToLeft
        spacing: 5
        padding: 10
        Button {
            text: qsTr("Cancel")
            onClicked: {
                newSettingPopup.reject()
                newSettingPopup.setData()
            }
        }
        Button {
            text: qsTr("Ok")
            onClicked: {
                newSettingPopup.accept();
                newSettingPopup.setData();
            }
        }
    }
}
