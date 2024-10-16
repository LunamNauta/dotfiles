local module = {}

function module:init()
    wvim = vim.deepcopy(require("wvim.config.defaults"))
    require("wvim.utils"):init()

    local settings = require("wvim.config.settings")
    settings.load_defaults()

    local keymaps = require("wvim.config.keymaps")
    keymaps.load_defaults()

    local usercmds = require("wvim.config.usercmds")
    usercmds.load_defaults()
end

return module
