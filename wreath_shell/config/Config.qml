pragma Singleton

import Quickshell.Io
import Quickshell

Singleton{
    id: root

    property alias appearance: adapter.appearance
    property alias background: adapter.background
    property alias services: adapter.services
    property alias session: adapter.session
    property alias border: adapter.border

    ElapsedTimer{
        id: timer
    }

    FileView {
        path: ""
        watchChanges: true
        onFileChanged: {
            timer.restart();
            reload();
        }
 
        JsonAdapter{
            id: adapter

            property AppearanceConfig appearance: AppearanceConfig{}
            property BackgroundConfig background: BackgroundConfig{}
            property ServiceConfig services: ServiceConfig{}
            property SessionConfig session: SessionConfig{}
            property BorderConfig border: BorderConfig{}
        }
    }
}
