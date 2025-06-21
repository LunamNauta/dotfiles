import { bind } from "astal";
import { Widget } from "astal/gtk4";
import { globals } from "./Globals";
import Battery from "gi://AstalBattery"

function CPUMon_Usage_Widget(){
    return Widget.Box(
        { cssClasses: ['cpumon', 'usage'] },
        Widget.Label({ cssClasses: ['cpumon', 'icon'], label: '' }),
        Widget.Label({ cssClasses: ['cpumon', 'percent'], label: bind(globals.sysmon.curr_cpuusage).as(usage => globals.utilities.format_percent(usage, 3) + '%') })
    );
}
function MemMon_Usage_Widget(){
    return Widget.Box(
        { cssClasses: ['memmon'] },
        Widget.Label({ cssClasses: ['memmon', 'icon'], label: '' }),
        Widget.Label({ cssClasses: ['memmon', 'percent'], label: bind(globals.sysmon.curr_memusage).as(usage => globals.utilities.format_percent(usage, 3) + '%') })
    );
}
function CPUMon_Temp_Widget(){
    return Widget.Box(
        { cssClasses: ['cpumon'] },
        Widget.Label({ cssClasses: ['cpumon', 'icon'], label: '' }),
        Widget.Label({ cssClasses: ['cpumon', 'percent'], label: bind(globals.sysmon.cpu_temp).as(temp => globals.utilities.format_percent(temp, 3, 1) + '°') })
    );
}
function GPUMon_Temp_Widget(){
    return Widget.Box(
        { cssClasses: ['gpumon', 'temp'] },
        Widget.Label({ cssClasses: ['gpumon', 'icon'], label: '󰺵' }),
        Widget.Label({ cssClasses: ['gpumon', 'percent'], label: bind(globals.sysmon.gpu_temp).as(temp => globals.utilities.format_percent(temp, 3, 1) + '°') })
    );
}

function Sysmon_Widget(){
    return Widget.Box(
        { cssClasses: ['system-monitor'] },
        CPUMon_Usage_Widget(),
        MemMon_Usage_Widget(),
        CPUMon_Temp_Widget(),
        GPUMon_Temp_Widget(),
    );
}

export { Sysmon_Widget };
