import qs.services
import qs.config

StyledText {
    property real fill
    property int grade: -25

    font.family: Config.appearance.font.family.material
    font.pointSize: Config.appearance.font.size.larger
    font.variableAxes: ({
        FILL: fill.toFixed(1),
        GRAD: grade,
        opsz: fontInfo.pixelSize,
        wght: fontInfo.weight
    })
}
