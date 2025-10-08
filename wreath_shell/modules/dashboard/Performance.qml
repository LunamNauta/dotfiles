import qs.components
import qs.components.misc
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    readonly property int padding: Config.appearance.padding.large

    function displayTemp(temp: real): string {
        return `${Math.ceil(Config.services.use_fahrenheit ? temp * 1.8 + 32 : temp)}°${Config.services.use_fahrenheit ? "F" : "C"}`;
    }

    spacing: Config.appearance.spacing.large * 3

    Ref {
        service: SystemUsage
    }

    Resource {
        Layout.alignment: Qt.AlignVCenter
        Layout.topMargin: root.padding
        Layout.bottomMargin: root.padding
        Layout.leftMargin: root.padding * 2

        value1: Math.min(1, SystemUsage.gpu_temp / 90)
        value2: SystemUsage.gpu_perc

        label1: root.displayTemp(SystemUsage.gpu_temp)
        label2: `${Math.round(SystemUsage.gpu_perc * 100)}%`

        sublabel1: qsTr("GPU temp")
        sublabel2: qsTr("Usage")
    }

    Resource {
        Layout.alignment: Qt.AlignVCenter
        Layout.topMargin: root.padding
        Layout.bottomMargin: root.padding

        primary: true

        value1: Math.min(1, SystemUsage.cpu_temp / 90)
        value2: SystemUsage.cpu_perc

        label1: root.displayTemp(SystemUsage.cpu_temp)
        label2: `${Math.round(SystemUsage.cpu_perc * 100)}%`

        sublabel1: qsTr("CPU temp")
        sublabel2: qsTr("Usage")
    }

    Resource {
        Layout.alignment: Qt.AlignVCenter
        Layout.topMargin: root.padding
        Layout.bottomMargin: root.padding
        Layout.rightMargin: root.padding * 3

        value1: SystemUsage.mem_perc
        value2: SystemUsage.storage_perc

        label1: {
            const fmt = SystemUsage.formatKib(SystemUsage.mem_used);
            return `${+fmt.value.toFixed(1)}${fmt.unit}`;
        }
        label2: {
            const fmt = SystemUsage.formatKib(SystemUsage.storage_used);
            return `${Math.floor(fmt.value)}${fmt.unit}`;
        }

        sublabel1: qsTr("Memory")
        sublabel2: qsTr("Storage")
    }

    component Resource: Item {
        id: res

        required property real value1
        required property real value2
        required property string sublabel1
        required property string sublabel2
        required property string label1
        required property string label2

        property bool primary
        readonly property real primaryMult: primary ? 1.2 : 1

        readonly property real thickness: Config.dashboard.sizes.resourceProgessThickness * primaryMult

        property color fg1: Colors.palette.m3primary
        property color fg2: Colors.palette.m3secondary
        property color bg1: Colors.palette.m3primaryContainer
        property color bg2: Colors.palette.m3secondaryContainer

        implicitWidth: Config.dashboard.sizes.resourceSize * primaryMult
        implicitHeight: Config.dashboard.sizes.resourceSize * primaryMult

        onValue1Changed: canvas.requestPaint()
        onValue2Changed: canvas.requestPaint()
        onFg1Changed: canvas.requestPaint()
        onFg2Changed: canvas.requestPaint()
        onBg1Changed: canvas.requestPaint()
        onBg2Changed: canvas.requestPaint()

        Column {
            anchors.centerIn: parent

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter

                text: res.label1
                font.pointSize: Config.appearance.font.size.extraLarge * res.primaryMult
            }

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter

                text: res.sublabel1
                color: Colors.palette.m3onSurfaceVariant
                font.pointSize: Config.appearance.font.size.smaller * res.primaryMult
            }
        }

        Column {
            anchors.horizontalCenter: parent.right
            anchors.top: parent.verticalCenter
            anchors.horizontalCenterOffset: -res.thickness / 2
            anchors.topMargin: res.thickness / 2 + Config.appearance.spacing.small

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter

                text: res.label2
                font.pointSize: Config.appearance.font.size.smaller * res.primaryMult
            }

            StyledText {
                anchors.horizontalCenter: parent.horizontalCenter

                text: res.sublabel2
                color: Colors.palette.m3onSurfaceVariant
                font.pointSize: Config.appearance.font.size.small * res.primaryMult
            }
        }

        Canvas {
            id: canvas

            readonly property real centerX: width / 2
            readonly property real centerY: height / 2

            readonly property real arc1Start: degToRad(45)
            readonly property real arc1End: degToRad(220)
            readonly property real arc2Start: degToRad(230)
            readonly property real arc2End: degToRad(360)

            function degToRad(deg: int): real {
                return deg * Math.PI / 180;
            }

            anchors.fill: parent

            onPaint: {
                const ctx = getContext("2d");
                ctx.reset();

                ctx.lineWidth = res.thickness;
                ctx.lineCap = Config.appearance.rounding.scale === 0 ? "square" : "round";

                const radius = (Math.min(width, height) - ctx.lineWidth) / 2;
                const cx = centerX;
                const cy = centerY;
                const a1s = arc1Start;
                const a1e = arc1End;
                const a2s = arc2Start;
                const a2e = arc2End;

                ctx.beginPath();
                ctx.arc(cx, cy, radius, a1s, a1e, false);
                ctx.strokeStyle = res.bg1;
                ctx.stroke();

                ctx.beginPath();
                ctx.arc(cx, cy, radius, a1s, (a1e - a1s) * res.value1 + a1s, false);
                ctx.strokeStyle = res.fg1;
                ctx.stroke();

                ctx.beginPath();
                ctx.arc(cx, cy, radius, a2s, a2e, false);
                ctx.strokeStyle = res.bg2;
                ctx.stroke();

                ctx.beginPath();
                ctx.arc(cx, cy, radius, a2s, (a2e - a2s) * res.value2 + a2s, false);
                ctx.strokeStyle = res.fg2;
                ctx.stroke();
            }
        }

        Behavior on value1 {
            Anim {}
        }

        Behavior on value2 {
            Anim {}
        }

        Behavior on fg1 {
            CAnim {}
        }

        Behavior on fg2 {
            CAnim {}
        }

        Behavior on bg1 {
            CAnim {}
        }

        Behavior on bg2 {
            CAnim {}
        }
    }
}
