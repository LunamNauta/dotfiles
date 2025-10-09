import QtQuick

MouseArea{
    property int scroll_accumulated_y: 0

    function onWheel(event: WheelEvent): void{}

    onWheel: event => {
        // Update accumulated scroll
        if (Math.sign(event.angleDelta.y) !== Math.sign(scroll_accumulated_y)) scroll_accumulated_y = 0;
        scroll_accumulated_y += event.angleDelta.y;
        // Trigger handler and reset if above threshold
        if (Math.abs(scroll_accumulated_y) >= 120){
            onWheel(event);
            scroll_accumulated_y = 0;
        }
    }
}
