import { bind, Variable } from "astal";
import AstalHyprland from "gi://AstalHyprland?version=0.1";
import Gio from "gi://Gio?version=2.0";
import GLib from "gi://GLib?version=2.0";
import GTop from "gi://GTop?version=2.0";

class utilities_t{
    format_string(format: string, data: any){
        return format.replace(/\{(\w+)\}/g, (_, key) => {
            return data[key];
        });
    }
    format_percent(number: number, digits: number, scale: number = 100){
        let str = (parseFloat(number.toFixed(digits)) * scale).toString()
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

class sysmon_t{
    curr_memusage: Variable<number>;
    curr_cpuusage: Variable<number>;
    curr_mem_data: Variable<GTop.glibtop_mem>;
    curr_cpu_data: Variable<GTop.glibtop_cpu>;
    cpu_interface_file: string
    gpu_interface_file: string
    cpu_temp: Variable<number>
    gpu_temp: Variable<number>
    decoder: TextDecoder;

    constructor(){
        this.curr_memusage = Variable(0);
        this.curr_cpuusage = Variable(0);
        this.curr_mem_data = Variable(new GTop.glibtop_mem()).poll(1000, () => {
            const mem = new GTop.glibtop_mem();
            GTop.glibtop.get_mem(mem);
            this.curr_memusage.set(mem.user / mem.total);
            return mem;
        });
        this.curr_cpu_data = Variable(new GTop.glibtop_cpu()).poll(1000, () => {
            const cpu = new GTop.glibtop_cpu();
            GTop.glibtop.get_cpu(cpu);
            const total_dif = cpu.total - this.curr_cpu_data.get().total;
            const idle_dif = cpu.idle - this.curr_cpu_data.get().idle;
            if (total_dif <= 0) this.curr_cpuusage.set(0);
            else this.curr_cpuusage.set((total_dif - idle_dif) / total_dif);
            return cpu;
        });
        this.decoder = new TextDecoder();
        this.cpu_interface_file = this.find_cpu_hwmon() ?? '';
        this.cpu_temp = Variable(0).poll(1000, () => {
            let [success, contents] = GLib.file_get_contents(this.cpu_interface_file + '/temp1_input');
            if (success) {
                let text = this.decoder.decode(contents);
                return parseFloat(text) / 1000;
            }
            return -1.0;
        });
        this.gpu_interface_file = this.find_amdgpu_hwmon() ?? '';
        this.gpu_temp = Variable(0).poll(1000, () => {
            let [success, contents] = GLib.file_get_contents(this.gpu_interface_file + '/temp1_input');
            if (success){
                let text = this.decoder.decode(contents);
                return parseFloat(text) / 1000;
            }
            return -1.0;
        });
    };

    find_cpu_hwmon(){
        const hwmonRoot = '/sys/class/hwmon';
        const directory = Gio.File.new_for_path(hwmonRoot);
        let enumerator = directory.enumerate_children('standard::*', Gio.FileQueryInfoFlags.NONE, null);

        let fileInfo;
        while ((fileInfo = enumerator.next_file(null)) !== null) {
            let child = enumerator.get_child(fileInfo);
            let name = child.get_child('name');
            let [success, contents] = name.load_contents(null);
            if (success){
                const text = this.decoder.decode(contents).toString();
                const cpustr = "k10temp";
                if (text.length-1 != cpustr.length) continue;
                for (let a = 0; a < cpustr.length; a++) if (text[a] != cpustr[a]) continue;
                return child.get_path();
            }
        }
        return null
    }
    find_amdgpu_hwmon(){
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
};

type workspace_data_t = {
    is_occupied: boolean;
    is_focused: boolean;
    id: number;
};
type workspace_group_t = {
    is_occupied: boolean;
    workspaces: workspace_data_t[];
};

class hypr_t{
    hypr = AstalHyprland.get_default();
    curr_client = bind(this.hypr, 'focused_client');
    curr_workspace = bind(this.hypr, 'focused_workspace');
    curr_workspaces = bind(this.hypr, 'workspaces').as(workspaces => this.get_grouped_workspaces(workspaces));

    get_grouped_workspaces(occupied_workspaces: AstalHyprland.Workspace[]){
        let workspace_groups: workspace_group_t[] = [];
        for (let workspace_id = 1; workspace_id <= 10; workspace_id++){
            const is_focused = workspace_id == this.curr_workspace.get().id;
            const workspace_data = {is_focused: is_focused, id: workspace_id};
            const is_occupied = occupied_workspaces.some(occ_workspace => occ_workspace.id == workspace_id);
            if (workspace_groups.length > 0 && workspace_groups.at(-1).is_occupied == is_occupied){
                workspace_groups.at(-1).workspaces.push(workspace_data);
                continue;
            }
            workspace_groups.push({is_occupied: is_occupied, workspaces: [workspace_data]});
        }
        return workspace_groups;
    }

    start_time = Date.now();
    scroll_workspace(delta: number){
        const end_time = Date.now();
        const dt = end_time - this.start_time;
        if (dt < 50) return;
        this.start_time = end_time;
        if (this.curr_workspace.get().id > 10) this.set_workspace(10);
        if (this.curr_workspace.get().id < 1) this.set_workspace(1);
        if (delta == 0) return;
        if (delta > 0 && this.hypr.focused_workspace.id == 10) return;
        if (delta < 0 && this.curr_workspace.get().id == 1) return;
        this.hypr.message(`dispatch workspace ${delta > 0 ? '+1' : '-1'}`);
    }
    set_workspace(id: number){
        if (id > 10 || id < 1) return;
        this.hypr.message(`dispatch workspace ${id}`);
    }
};

class globals_t{
    datetime = Variable(GLib.DateTime.new_now_local()).poll(1000, () => GLib.DateTime.new_now_local());
    utilities = new utilities_t();
    sysmon = new sysmon_t();
    hypr = new hypr_t();
};

const globals = new globals_t();
export { globals };
