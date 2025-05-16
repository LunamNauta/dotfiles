import Gtk from "gi://Gtk?version=3.0";
import AstalWp from "gi://AstalWp?version=0.1";

const audio = AstalWp.get_default()?.audio

console.log(audio?.speakers.length);

const Audio_Widget = () =>
<box className={'audio'} orientation={Gtk.Orientation.VERTICAL}>
</box>

export{
    Audio_Widget
};
