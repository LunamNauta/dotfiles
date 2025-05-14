import { bind  } from "astal"
import { datetime_ctx } from "./types"

const Clock_Widget = () =>
<box className={'clock'}>
    <label
        className="clock time"
        label={bind(datetime_ctx).as(datetime => datetime.format('%H:%M:%S')!)}
    />
    <label label={'•'}/>
    <label
        className="clock date"
        label={bind(datetime_ctx).as(datetime => datetime.format('%A, %d/%m')!)}
    />
</box>

export{
    Clock_Widget
};
