import QtQuick 2.15
import QtQml.Models 2.15
import "." as App

App.ListView  {
    id: userCenter
    boundsBehavior: ListView.StopAtBounds
    spacing: 4
    model: ObjectModel {
        Rectangle {
            width: userCenter.width
            height: 100
            color: "white"
        }

        Rectangle {
            width: userCenter.width
            height: 50
            color: "white"

            Text {
                text: "My works"
            }
        }
    }
}
