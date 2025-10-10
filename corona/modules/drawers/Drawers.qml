pragma ComponentBehavior: Bound

import qs.components.containers
import qs.modules.settings as Settings
import qs.modules.bar as Bar
import qs.components
import qs.services
import qs.config

import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick.Effects
import Quickshell
import QtQuick
import QtQuick.Layouts

Variants{
    id: root

    model: Quickshell.screens

    Scope{
        id: scope

        required property ShellScreen modelData

        StyledWindow{
            id: win

            readonly property bool has_fullscreen: Hypr.monitorFor(screen)?.active_workspace?.toplevels.values.some(t => t.lastIpcObject.fullscreen === 2) ?? false

            onHas_fullscreenChanged: {
                visibilities.session = false;
                visibilities.dashboard = false;
                visibilities.osd = false;
            }

            screen: scope.modelData
            name: "drawers"
            WlrLayershell.exclusionMode: ExclusionMode.Ignore
            WlrLayershell.keyboardFocus: visibilities.session ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

            mask: Region{
                x: bar.implicitWidth + Config.bar.padding * 2
                y: Config.border.thickness
                width: win.width - bar.implicitWidth - Config.bar.padding * 2 - Config.border.thickness
                height: win.height - Config.border.thickness * 2
                intersection: Intersection.Xor

                regions: regions.instances
            }

            anchors.top: true
            anchors.bottom: true
            anchors.left: true
            anchors.right: true

            Variants{
                id: regions

                model: panels.children

                Region{
                    required property Item modelData

                    x: modelData.x
                    y: modelData.y
                    width: modelData.width + Config.border.thickness
                    height: modelData.height + Config.border.thickness
                    intersection: Intersection.Subtract
                }
            }

            HyprlandFocusGrab{
                id: focus_grab

                active: visibilities.dashboard || visibilities.session
                windows: [win]
                onCleared: {
                    //visibilities.osd = false;
                    visibilities.dashboard = false;
                    visibilities.session = false;
                }
            }

            Item{
                anchors.fill: parent
                opacity: 1
                layer.enabled: true
                layer.effect: MultiEffect{
                    shadowEnabled: true
                    blurMax: 15
                    shadowColor: Qt.alpha(Colors.palette.m3shadow, 0.7)
                }

                Border{
                    bar: bar
                }

                Backgrounds{
                    panels: panels
                }
            }

            PersistentProperties{
                id: visibilities

                property bool osd
                property bool session
                property bool dashboard
                property bool settings

                Component.onCompleted: Visibilities.load(scope.modelData, this)
            }

            Interactions{
                screen: scope.modelData
                visibilities: visibilities
                panels: panels
                bar: bar

                Panels{
                    id: panels

                    screen: scope.modelData
                    visibilities: visibilities
                    bar: bar
                }

                Bar.Wrapper{
                    id: bar

                    screen: scope.modelData
                    visibilities: visibilities

                    anchors.left: parent.left
                    //anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                }
            }
        }
        LazyLoader{
            loading: Config.read_config_file
            Settings.Wrapper{
                bar: bar
            }
        }
    }
}
