import { bind, Gio, GLib, Variable } from "astal";
import { sysmon_ctx, utilities_ctx } from "./types";

async function find_cpu_hwmon() {
    const hwmonRoot = '/sys/class/hwmon';

    const decoder = new TextDecoder();
    const directory = Gio.File.new_for_path(hwmonRoot);
    let enumerator = directory.enumerate_children('standard::*', Gio.FileQueryInfoFlags.NONE, null);

    let fileInfo;
    while ((fileInfo = enumerator.next_file(null)) !== null) {
        let child = enumerator.get_child(fileInfo);
        let name = child.get_child('name');
        let [success, contents] = name.load_contents(null);
        if (success){
            const text = decoder.decode(contents).toString();
            const cpustr = "k10temp";
            if (text.length-1 != cpustr.length) continue;
            for (let a = 0; a < cpustr.length; a++) if (text[a] != cpustr[a]) continue;
            return child.get_path();
        }
    }
    return null
}

async function find_amdgpu_hwmon() {
    const hwmonRoot = '/sys/class/hwmon';

    const decoder = new TextDecoder();
    const directory = Gio.File.new_for_path(hwmonRoot);
    let enumerator = directory.enumerate_children('standard::*', Gio.FileQueryInfoFlags.NONE, null);

    let fileInfo;
    while ((fileInfo = enumerator.next_file(null)) !== null) {
        let child = enumerator.get_child(fileInfo);
        let name = child.get_child('name');
        let [success, contents] = name.load_contents(null);
        if (success){
            const text = decoder.decode(contents).toString();
            const amdstr = "amdgpu";
            if (text.length-1 != amdstr.length) continue;
            for (let a = 0; a < amdstr.length; a++) if (text[a] != amdstr[a]) continue;
            return child.get_path();
        }
    }
    return null
}

const cpu_interface_file = await find_cpu_hwmon();
const cpu_temp = Variable(0).poll(1000, () => {
    let [success, contents] = GLib.file_get_contents(cpu_interface_file + '/temp1_input');
    if (success) {
        let text = decoder.decode(contents);
        return parseFloat(text, 10) / 1000;
    }
    return -1.0;
});

const decoder = new TextDecoder();
const gpu_interface_file = await find_amdgpu_hwmon();
const gpu_temp = Variable(0).poll(1000, () => {
    let [success, contents] = GLib.file_get_contents(gpu_interface_file + '/temp1_input');
    if (success) {
        let text = decoder.decode(contents);
        return parseFloat(text, 10) / 1000;
    }
    return -1.0;
});

const CPUMon_Widget = () =>
<box className="cpumon">
    <label className={'cpumon icon'} label={''}/>
    <label
        className="cpumon percent"
        label={bind(sysmon_ctx.curr_cpuusage).as(cpu => utilities_ctx.format_percent(cpu, 3) + '%')}
    />
</box>

const CPUMon_Temp_Widget = () =>
<box className="cpumon temp">
    <label className={'cpumon temp icon'} label={''}/>
    <label
        className="cpumon temp percent"
        label={bind(cpu_temp).as(cpu => utilities_ctx.format_percent(cpu, 3, 1) + '°')}
    />
</box>

const MemMon_Widget = () =>
<box className="memmon">
    <label className={'memmon icon'} label={''}/>
    <label
        className="memmon percent"
        label={bind(sysmon_ctx.curr_memusage).as(mem => utilities_ctx.format_percent(mem, 3) + '%')}
    />
</box>


const GPUMon_Temp_Widget = () =>
<box className={"gpumon temp"}>
    <label className={'gpumon temp icon'} label={'󰺵'}/>
    <label
        className="gpumon temp percent"
        label={bind(gpu_temp).as(gpu => utilities_ctx.format_percent(gpu, 3, 1) + '°')}
    />
</box>

const System_Monitor_Widget = () =>
<box className={'system-monitor'}>
    <CPUMon_Widget/>
    <MemMon_Widget/>
    <CPUMon_Temp_Widget/>
    <GPUMon_Temp_Widget/>
</box>

export{
    System_Monitor_Widget
};
