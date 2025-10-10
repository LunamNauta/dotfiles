import qs.components.controls
import qs.config

import Quickshell
import QtQuick

CustomMouseArea{
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property Panels panels
    required property Item bar

    function withinPanelHeight(panel: Item, x: real, y: real): bool {
        const panelY = Config.border.thickness + panel.y;
        // TODO: Fix this bullshit. Why does that -1 have to be there? What?
        return y >= panelY && y <= panelY + panel.height - 1;
    }

    function withinPanelWidth(panel: Item, x: real, y: real): bool {
        const panelX = panel.x + Config.border.thickness;
        return x >= panelX && x <= panelX + panel.width;
    }

    function inLeftPanel(panel: Item, x: real, y: real): bool {
        return x < bar.implicitWidth + Config.bar.padding * 2 + panel.x + panel.width && withinPanelHeight(panel, x, y);
    }

    function inRightPanel(panel: Item, x: real, y: real): bool {
        return x > panel.x + Config.border.thickness && withinPanelHeight(panel, x, y);
    }

    function inTopPanel(panel: Item, x: real, y: real): bool {
        return y < Config.border.thickness + panel.y + panel.height && withinPanelWidth(panel, x, y);
    }

    function inBottomPanel(panel: Item, x: real, y: real): bool {
        return y > root.height - Config.border.thickness - panel.height - Config.border.rounding && withinPanelWidth(panel, x, y);
    }

    function onWheel(event: WheelEvent): void {
        if (event.x < bar.implicitWidth + Config.bar.padding * 2) {
            bar.handleWheel(event.y, event.angleDelta);
        }
    }

    anchors.fill: parent
    hoverEnabled: true

    onExited: {
        //visibilities.dashboard = false
        //visibilities.osd = false
    }

    onPositionChanged: event => {
        const x = event.x;
        const y = event.y;

        //visibilities.session = inRightPanel(panels.session, x, y);
        visibilities.dashboard = inTopPanel(panels.dashboard, x, y);
        visibilities.osd = inRightPanel(panels.osd, x, y);
    }
}
