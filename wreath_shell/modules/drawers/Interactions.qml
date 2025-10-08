import qs.components.controls
import qs.config

import Quickshell
import QtQuick

CustomMouseArea{
    id: root

    required property ShellScreen screen
    required property PersistentProperties visibilities
    required property Panels panels

    function withinPanelHeight(panel: Item, x: real, y: real): bool {
        const panelY = panel.y;
        return y >= panelY - Config.border.rounding && y <= panelY + panel.height + Config.border.rounding;
    }

    function withinPanelWidth(panel: Item, x: real, y: real): bool {
        const panelX = Config.border.thickness + panel.x;
        return x >= panelX - Config.border.rounding && x <= panelX + panel.width + Config.border.rounding;
    }

    function inLeftPanel(panel: Item, x: real, y: real): bool {
        return x < Config.border.thickness + panel.x + panel.width && withinPanelHeight(panel, x, y);
    }

    function inRightPanel(panel: Item, x: real, y: real): bool {
        return x > panel.x && withinPanelHeight(panel, x, y);
    }

    //TODO: Fix this
    function inTopPanel(panel: Item, x: real, y: real): bool {
        return y < Config.border.thickness && panel.y + panel.height && withinPanelWidth(panel, x, y);
    }

    // TODO: Fix this
    function inBottomPanel(panel: Item, x: real, y: real): bool {
        return y > root.height - Config.border.thickness - panel.height - Config.border.rounding && withinPanelWidth(panel, x, y);
    }

    anchors.fill: parent
    hoverEnabled: true

    onPositionChanged: event => {
        const x = event.x;
        const y = event.y;

        visibilities.session = inRightPanel(panels.session, x, y);
    }

}
