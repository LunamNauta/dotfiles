import { bind } from "astal";
import { sysmon_ctx, utilities_ctx } from "./types";

const CPUMon_Widget = () =>
<box className="cpumon">
    <label className={'cpumon icon'} label={''}/>
    <label
        className="cpumon percent"
        label={bind(sysmon_ctx.curr_cpuusage).as(cpu => utilities_ctx.format_percent(cpu, 3) + '%')}
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

const System_Monitor_Widget = () =>
<box className={'system-monitor'}>
    <CPUMon_Widget/>
    <MemMon_Widget/>
</box>

export{
    System_Monitor_Widget
};
