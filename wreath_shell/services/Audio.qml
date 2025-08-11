pragma Singleton

import Quickshell.Services.Pipewire
import Quickshell

Singleton {
    id: root

    readonly property var nodes: Pipewire.nodes.values.reduce((acc, node) => {
        if (!node.isStream){
            if (node.isSink) acc.sinks.push(node);
            else if (node.audio) acc.sources.push(node);
        }
        return acc;
    }, {
        sources: [],
        sinks: []
    })

    readonly property list<PwNode> sources: nodes.sources
    readonly property list<PwNode> sinks: nodes.sinks

    readonly property PwNode source: Pipewire.defaultAudioSource
    readonly property PwNode sink: Pipewire.defaultAudioSink

    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: !!sink?.audio?.muted

    function setVolume(newVolume: real): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false;
            sink.audio.volume = Math.max(0, Math.min(1, newVolume));
        }
    }

    function incrementVolume(amount: real): void {
        setVolume(volume + (amount || 0.1));
    }

    function decrementVolume(amount: real): void {
        setVolume(volume - (amount || 0.1));
    }

    function setAudioSink(new_sink: PwNode): void {
        Pipewire.preferredDefaultAudioSink = new_sink;
    }

    function setAudioSource(new_source: PwNode): void {
        Pipewire.preferredDefaultAudioSource = new_source;
    }

    PwObjectTracker {
        objects: [...root.sinks, ...root.sources]
    }
}
