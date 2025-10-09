import Quickshell.Io

JsonObject{
    property bool persistent: true
    property bool show_on_hover: true
    property Sizes sizes: Sizes {}
    property list<var> entries: [
        {
            id: "logo",
            enabled: true
        }
    ]

    component Sizes: JsonObject{
        property int inner_width: 40
        property int battery_width: 250
        property int network_width: 320
    }
}
