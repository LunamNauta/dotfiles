pragma Singleton

import qs.config

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton{
    id: root

    property string previous_sink_name: ""
    property string previous_source_name: ""

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

    readonly property list<PwNode> sinks: nodes.sinks
    readonly property list<PwNode> sources: nodes.sources

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool muted: !!sink?.audio?.muted
    readonly property real volume: sink?.audio?.volume ?? 0

    readonly property bool source_muted: !!source?.audio?.muted
    readonly property real source_volume: source?.audio?.volume ?? 0


    function setVolume(new_volume: real): void{
        if (sink?.ready && sink?.audio){
            sink.audio.muted = false;
            sink.audio.volume = Math.max(0, Math.min(1, new_volume));
        }
    }
    function incrementVolume(amount: real): void{
        setVolume(volume + (amount || Config.services.audio_increment));
    }
    function decrementVolume(amount: real): void{
        setVolume(volume - (amount || Config.services.audio_increment));
    }

    function setSourceVolume(new_volume: real): void{
        if (source?.ready && source?.audio){
            source.audio.muted = false;
            source.audio.volume = Math.max(0, Math.min(1, new_volume));
        }
    }
    function incrementSourceVolume(amount: real): void{
        setSourceVolume(source_volume + (amount || Config.services.audio_increment));
    }

    function decrementSourceVolume(amount: real): void{
        setSourceVolume(source_volume - (amount || Config.services.audio_increment));
    }

    function setAudioSink(new_sink: PwNode): void{
        Pipewire.preferredDefaultAudioSink = new_sink;
    }
    function setAudioSource(new_source: PwNode): void {
        Pipewire.preferredDefaultAudioSource = new_source;
    }

    onSinkChanged: {
        if (!sink?.ready) return;
        const new_sink_name = sink.description || sink.name || qsTr("Unknown Device");
        if (previous_sink_name && previous_sink_name !== new_sink_name){
            console.log(qsTr("Audio output changed") + ". " + qsTr("Now using: %1").arg(new_sink_name));
        }
        previous_sink_name = new_sink_name;
    }

    onSourceChanged: {
        if (!source?.ready) return;
        const new_source_name = source.description || source.name || qsTr("Unknown Device");
        if (previous_source_name && previous_source_name !== new_source_name){
            console.log(qsTr("Audio input changed") + ". " + qsTr("Now using: %1").arg(new_source_name));
        }
        previous_source_name = new_source_name;
    }

    Component.onCompleted:{
        previous_sink_name = sink?.description || sink?.name || qsTr("Unknown Device");
        previous_source_name = source?.description || source?.name || qsTr("Unknown Device");
    }

    PwObjectTracker{
        objects: [...root.sinks, ...root.sources]
    }
}
