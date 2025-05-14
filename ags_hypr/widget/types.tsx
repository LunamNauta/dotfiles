import { bind, Variable } from "astal";
import AstalHyprland from "gi://AstalHyprland?version=0.1";
import GLib from "gi://GLib";
import GTop from "gi://GTop?version=2.0";

class utilities_ctx_t{
    format_string(format: string, data: any){
        return format.replace(/\{(\w+)\}/g, (_, key) => {
            return data[key];
        });
    }
    format_percent(number: number, digits: number){
        let str = (parseFloat(number.toFixed(digits)) * 100).toString()
        if (str.length < digits) str += '.' + ('0'.repeat(digits - str.length))
        else if (str.length == digits) str += '0'
        else str = str.substring(0, Math.min(str.length, digits+1))
        return str
    }
    string_max(input: string, len: number){
        if (input.length > len) return input.substring(0, len-3) + '...';
        return input;
    }
};

type workspace_data_t = {
    is_focused: boolean;
    id: number;
};

type workspace_group_t = {
    is_occupied: boolean;
    workspaces: workspace_data_t[];
};

class sysmon_ctx_t{
    curr_memusage = Variable(0);
    curr_cpuusage = Variable(0);
    curr_mem_data = Variable(new GTop.glibtop_mem()).poll(1000, () => {
        const mem = new GTop.glibtop_mem();
        GTop.glibtop.get_mem(mem);
        this.curr_memusage.set(mem.user / mem.total);
        return mem;
    });
    curr_cpu_data = Variable(new GTop.glibtop_cpu()).poll(1000, () => {
        const cpu = new GTop.glibtop_cpu();
        GTop.glibtop.get_cpu(cpu);
        const total_dif = cpu.total - this.curr_cpu_data.get().total;
        const idle_dif = cpu.idle - this.curr_cpu_data.get().idle;
        if (total_dif <= 0) this.curr_cpuusage.set(0);
        else this.curr_cpuusage.set((total_dif - idle_dif) / total_dif);
        return cpu;
    });
};

class hypr_ctx_t{
    hypr = AstalHyprland.get_default();
    curr_client = bind(this.hypr, 'focused_client');
    curr_workspace = bind(this.hypr, 'focused_workspace');
    curr_workspaces = bind(this.hypr, 'workspaces').as(workspaces => this.get_grouped_workspaces(workspaces));

    get_grouped_workspaces(occupied_workspaces: AstalHyprland.Workspace[]){
        let workspace_groups: workspace_group_t[] = [];
        for (let workspace_id = 1; workspace_id <= 9; workspace_id++){
            const is_focused = workspace_id == this.curr_workspace.get().id;
            const workspace_data = {is_focused: is_focused, id: workspace_id};
            const is_occupied = occupied_workspaces.some(occ_workspace => occ_workspace.id == workspace_id);
            if (workspace_groups.length != 0 && workspace_groups.at(-1).is_occupied == is_occupied){
                workspace_groups.at(-1).workspaces.push(workspace_data);
                continue;
            }
            workspace_groups.push({is_occupied: is_occupied, workspaces: [workspace_data]});
        }
        return workspace_groups;
    }

    scroll_workspace(delta: number){
        if (delta == 0) return;
        const delta_str = delta > 0 ? '+1' : '-1';
        if (delta > 0 && this.curr_workspace.get().id == 9) return;
        if (delta < 0 && this.curr_workspace.get().id == 0) return;
        this.hypr.message(`dispatch workspace ${delta_str}`);
    }
    set_workspace(id: number){
        if (id > 9 || id < 0) return;
        this.hypr.message(`dispatch workspace ${id}`);
    }
};

const datetime_ctx = Variable(GLib.DateTime.new_now_local()).poll(1000, () => GLib.DateTime.new_now_local());
const utilities_ctx = new utilities_ctx_t();
const sysmon_ctx = new sysmon_ctx_t();
const hypr_ctx = new hypr_ctx_t();

export{
    datetime_ctx,
    utilities_ctx,
    sysmon_ctx,
    hypr_ctx
};
