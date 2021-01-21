pragma Singleton
import QtQuick 2.15

// Controls Box model
QtObject {

    readonly property int baseHeight: 25
    readonly property int baseWidth: 100

    readonly property int topInset: 0
    readonly property int bottomInset: 0
    readonly property int leftInset: 0
    readonly property int rightInset: 0

    readonly property int topPadding: 4
    readonly property int bottomPadding: 4
    readonly property int leftPadding: 8
    readonly property int rightPadding: 8

    readonly property int spacing: 4

    // like hover, but not focus
    readonly property color backgroundActive: "#7cabb1"
    readonly property color backgroundFocus: "#aaa"
    readonly property color backgroundInActive: "#e2e1e4"

    readonly property color contentActive: "#797465"
    readonly property color contentInActive: "#797352"
    readonly property color contentFocus: "#894658"

    // other colors
    readonly property color color1: "#3e3841" // 剑锋紫
    readonly property color color2: "#35333c" // 沙鱼灰
    readonly property color color3: "#7cabb1" // 闪蓝
    readonly property color color4: "#a61b29" // 苋菜红
    readonly property color color5: "#495c69" // 战舰灰
    readonly property color color6: "#74787a" // 嫩灰
    readonly property color color7: "#f1939c" // 春梅红

    readonly property int toolBarHeight: 40
}
