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
    property alias session: adapter.session
    property alias services: adapter.services

    ElapsedTimer{
        id: timer
    }

    FileView{
        path: `${Paths.config}/shell.json`
        watchChanges: true
        onFileChanged: {
            timer.restart();
            reload();
        }
        onLoaded: {
            try{
                JSON.parse(text());
            }
            catch (e){
                console.error("Error: Failed to read shell.json: " + e.message());
            }
        }
        onLoadFailed: err => {
            if (err !== FileViewError.FileNotFound) console.error("Error: Failed to read shell.json: " + FileViewError.toString(err));
        }
        onSaveFailed: err => console.error("Error: Failed to save shell.json: " + FileViewError.toString(err))

        JsonAdapter{
            id: adapter

            property AppearanceConfig appearance: AppearanceConfig{}
            property BackgroundConfig background: BackgroundConfig{}
            property BarConfig bar: BarConfig{}
            property BorderConfig border: BorderConfig{}
            property DashboardConfig dashboard: DashboardConfig{}
            property SessionConfig session: SessionConfig{}
            property ServiceConfig services: ServiceConfig{}
        }
    }
}
