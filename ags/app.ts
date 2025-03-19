import { App } from "astal/gtk3"
import style from "./style.scss"
import Bar from "./widget/Bar"

import { popup } from "./widget/popup"

App.start({
    css: style,
    main() {
        App.get_monitors().map(Bar)
        //App.get_monitors().map(popup())

        //const tmp_window = popup()
    },
})
