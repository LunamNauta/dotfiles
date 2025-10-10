import Quickshell.Io

JsonObject {
    property bool enabled: true
    property int hide_delay: 2000
    property Sizes sizes: Sizes {}

    component Sizes: JsonObject {
        property int slider_width: 30
        property int slider_height: 150
    }
}
