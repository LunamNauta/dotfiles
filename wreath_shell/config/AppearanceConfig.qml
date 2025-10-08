import Quickshell.Io

JsonObject{
    property Rounding rounding: Rounding{}
    property Spacing spacing: Spacing{}
    property Padding padding: Padding{}
    property FontInfo font: FontInfo{}
    property AnimInfo anim: AnimInfo{}
    property Transparency transparency: Transparency{}

    component Rounding: JsonObject{
        property real scale: 1
        property int small: 12 * scale
        property int normal: 17 * scale
        property int large: 25 * scale
        property int full: 1000 * scale
    }

    component Spacing: JsonObject{
        property real scale: 1
        property int small: 7 * scale
        property int smaller: 10 * scale
        property int normal: 12 * scale
        property int larger: 15 * scale
        property int large: 20 * scale
    }

    component Padding: JsonObject{
        property real scale: 1
        property int small: 5 * scale
        property int smaller: 7 * scale
        property int normal: 10 * scale
        property int larger: 12 * scale
        property int large: 15 * scale
    }

    component FontFamily: JsonObject{
        property string sans: "Caskaydia Mono NFM"
        property string mono: "Caskaydia Mono NFM"
        property string material: "Material Symbols Rounded"
        property string clock: "Caskaydia Mono NFM"
    }

    component FontSize: JsonObject{
        property real scale: 1
        property int small: 11 * scale
        property int smaller: 12 * scale
        property int normal: 13 * scale
        property int larger: 15 * scale
        property int large: 18 * scale
        property int extra_large: 28 * scale
    }

    component FontInfo: JsonObject{
        property FontFamily family: FontFamily{}
        property FontSize size: FontSize{}
    }

    component AnimCurves: JsonObject{
        property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
        property list<real> emphasized_accel: [0.3, 0, 0.8, 0.15, 1, 1]
        property list<real> emphasized_decel: [0.05, 0.7, 0.1, 1, 1, 1]
        property list<real> standard: [0.2, 0, 0, 1, 1, 1]
        property list<real> standard_accel: [0.3, 0, 1, 1, 1, 1]
        property list<real> standard_decel: [0, 0, 0, 1, 1, 1]
        property list<real> expressive_fast_spatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
        property list<real> expressive_default_spatial: [0.38, 1.21, 0.22, 1, 1, 1]
        property list<real> expressive_effects: [0.34, 0.8, 0.34, 1, 1, 1]
    }

    component AnimDurations: JsonObject{
        property real scale: 1
        property int small: 200 * scale
        property int normal: 400 * scale
        property int large: 600 * scale
        property int extra_large: 1000 * scale
        property int expressive_fast_spatial: 350 * scale
        property int expressive_default_spatial: 500 * scale
        property int expressive_effects: 200 * scale
    }

    component AnimInfo: JsonObject{
        property AnimCurves curves: AnimCurves{}
        property AnimDurations durations: AnimDurations{}
    }

    component Transparency: JsonObject{
        property bool enabled: false
        property real base: 0.85
        property real layers: 0.4
    }
}
