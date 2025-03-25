import { CircularProgress } from "astal/gtk3/widget";
import { Variable, bind, execAsync } from "astal"
import GTop from 'gi://GTop';

const Color_Picker = () =>
<button className={'color-picker'} onClick={() => execAsync('hyprpicker -a')}>
    <label label={''} />
</button>

export{
    Color_Picker
}
