import { App, Astal, Gtk, Gdk } from "astal/gtk3"

function popup(gdkmonitor: Gdk.Monitor) {
    const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

    const popup_window = <window
        className="Popup"
        gdkmonitor={gdkmonitor}
        exclusivity={Astal.Exclusivity.NORMAL}
        anchor={RIGHT | TOP}
        application={App}>
        <eventbox onHoverLost={() => popup_window.close()}>
            <button>
                test
            </button>
        </eventbox>
    </window>
}

export{
    popup
}
