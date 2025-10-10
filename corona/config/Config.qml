pragma Singleton

import qs.utils

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property alias appearance: adapter.appearance
    property alias background: adapter.background
    property alias bar: adapter.bar
    property alias border: adapter.border
    property alias dashboard: adapter.dashboard
    property alias osd: adapter.osd
    property alias session: adapter.session
    property alias services: adapter.services
    property alias hypr: adapter.hypr
    property bool read_config_file: false

    ElapsedTimer{
        id: timer
    }

    Process{
        id: proc_create_corona_config_dir
        command: ["zsh", "$HOME/personal/projects/corona/scripts/create_corona_config.zsh"]
    }

    FileView{
        id: file_shell_config
        path: `${Paths.config}/shell.json`
        watchChanges: true
        blockLoading: true
        onLoaded: {
            try{
                JSON.parse(text());
            }
            catch (e){
                console.error("Error: Failed to read shell.json: " + e.message());
            }
            root.read_config_file = true
            proc_create_corona_config_dir.running = true
        }
        onLoadFailed: err => {
            if (err !== FileViewError.FileNotFound) console.error("Error: Failed to read shell.json: " + FileViewError.toString(err));
            root.read_config_file = true
            proc_create_corona_config_dir.running = true
        }
        onSaveFailed: err => console.error("Error: Failed to save shell.json: " + FileViewError.toString(err))

        onAdapterUpdated: writeAdapter()
        onFileChanged: reload()

        JsonAdapter{
            id: adapter

            property AppearanceConfig appearance: AppearanceConfig{}
            property BackgroundConfig background: BackgroundConfig{}
            property BarConfig bar: BarConfig{}
            property BorderConfig border: BorderConfig{}
            property DashboardConfig dashboard: DashboardConfig{}
            property OsdConfig osd: OsdConfig {}
            property SessionConfig session: SessionConfig{}
            property ServiceConfig services: ServiceConfig{}
            property HyprConfig hypr: HyprConfig{}
        }
    }
}
