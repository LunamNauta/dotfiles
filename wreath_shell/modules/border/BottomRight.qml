import Quickshell
import QtQuick

PanelWindow{
    id: root

    required property real desiredRadius
    required property string desiredColor

	anchors{
		bottom: true
		right: true
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
			ctx.moveTo(width - radius, height);
			ctx.quadraticCurveTo(width, height, width, height - radius);
			ctx.lineTo(width, height);
			ctx.closePath();
			ctx.fill(); 
		}
	}
}
