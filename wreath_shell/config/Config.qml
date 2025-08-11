pragma Singleton

import Quickshell.Io
import Quickshell
import QtQuick

import qs.utils

Singleton {
    id: root

    property alias appearance: adapter.appearance
    property alias background: adapter.background
    property alias border: adapter.border

    FileView {
        path: `${Paths.stringify(Paths.config)}/shell.json`
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        JsonAdapter {
            id: adapter

            property AppearanceConfig appearance: AppearanceConfig {}
            property BackgroundConfig background: BackgroundConfig {}
            property BorderConfig border: BorderConfig {}
        }
    }
}
