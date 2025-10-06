import Quickshell
import QtQuick

PanelWindow{
    id: root

    required property real desiredRadius
    required property string desiredColor

	anchors{
		top: true
		left: true
    }

	implicitWidth: desiredRadius
	implicitHeight: desiredRadius
	color: "transparent"

	Canvas{
		anchors.fill: parent
		onPaint:{
			var ctx = getContext("2d");
			ctx.clearRect(0, 0, width, height);

			var radius = root.desiredRadius;

			ctx.fillStyle = root.desiredColor;
			ctx.beginPath();
			ctx.moveTo(0, radius);
			ctx.quadraticCurveTo(0, 0, radius, 0);
			ctx.lineTo(0, 0);
			ctx.closePath();
			ctx.fill();
		}
	}
}
