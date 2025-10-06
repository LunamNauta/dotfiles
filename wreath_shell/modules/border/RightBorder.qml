import Quickshell
import QtQuick

PanelWindow{
    id: root

    required property real desiredSize
    required property string desiredColor

	anchors{
        bottom: true
        top: true
		right: true
    }

	implicitWidth: desiredSize
	color: "transparent"

	Canvas{
		anchors.fill: parent
        onPaint:{
			var ctx = getContext("2d");
			ctx.clearRect(0, 0, width, height);
            ctx.fillStyle = root.desiredColor;
            ctx.fillRect(0, 0, width, height);
		}
    }
}
