import { CircularProgress } from "astal/gtk3/widget";
import { Variable, bind } from "astal"
import GTop from 'gi://GTop';

import { format_string, round_decimal } from "./utilities";
import { userOptions } from './settings'

const prevCpuData = Variable(new GTop.glibtop_cpu())
const cpuUsage = Variable(0).poll(userOptions.cpu.interval, () => {
    const currCpuData = new GTop.glibtop_cpu()
    GTop.glibtop_get_cpu(currCpuData)
    const totalDiff = currCpuData.total - prevCpuData.get().total;
    const idleDiff = currCpuData.idle - prevCpuData.get().idle;
    const cpuUsagePct = totalDiff > 0 ? (totalDiff - idleDiff) / totalDiff : 0;
    prevCpuData.set(currCpuData)
    return cpuUsagePct
})

const Cpu = () =>
<box className="cpu">
    <CircularProgress className={'cpu circ'}
        value={cpuUsage()}
        inverted={true}
        rounded={true}
    />
    <label
        className="cpu pct"
        label={bind(cpuUsage).as(usage => format_string(userOptions.cpu.format, {cpu: round_decimal(usage, 3)}))}
    />
</box>

export{
    Cpu
}
