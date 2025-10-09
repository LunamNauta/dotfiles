pragma Singleton

import qs.config
import qs.utils

import Quickshell
import QtQuick

Singleton{
    id: root

    property string city
    property var current_conditions
    property var forecast
    readonly property string icon: cc ? Icons.getWeatherIcon(current_conditions.weatherCode) : "cloud_alert"
    readonly property string description: current_conditions?.weatherDesc[0].value ?? qsTr("No weather")
    readonly property string temp_actual: Config.services.useFahrenheit ? `${current_conditions?.temp_F ?? 0}°F` : `${current_conditions?.temp_C ?? 0}°C`
    readonly property string temp_feel: Config.services.useFahrenheit ? `${current_conditions?.FeelsLikeF ?? 0}°F` : `${current_conditions?.FeelsLikeC ?? 0}°C`
    readonly property int humidity: cc?.humidity ?? 0

    function reload(): void{
        if (Config.services.weather_location) city = Config.services.weather_location;
        else if (!city && timer.elapsed() > 86400) Requests.get("https://ipinfo.io/json", text => {
            Config.services.weather_location = city ?? "";
            city = JSON.parse(text).city ?? "";
            timer.restart();
        });
    }

    onCityChanged: Requests.get(`https://wttr.in/${city}?format=j1`, text => {
        const json = JSON.parse(text);
        current_conditions = json.current_condition[0];
        forecast = json.weather;
    })

    ElapsedTimer{
        id: timer
    }
}
