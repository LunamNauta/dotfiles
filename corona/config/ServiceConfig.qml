import QtQuick
import Quickshell.Io

JsonObject{
    property string weather_location: "" // A lat,long pair or empty for autodetection, e.g. "37.8267,-122.4233"
    property bool use_fahrenheit: false //[Locale.ImperialUSSystem, Locale.ImperialSystem].includes(Qt.locale().measurementSystem)
    property bool use_twelve_hour_clock: false //Qt.locale().timeFormat(Locale.ShortFormat).toLowerCase().includes("a")
    property real brightness_increment: 0.1
    property real audio_increment: 0.1
}
