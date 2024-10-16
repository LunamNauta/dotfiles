local module = {}

function module:init()
    require("wvim.config"):init()

    local bootstrap = require("wvim.bootstrap")
    vim.cmd.colorscheme(wvim.colorscheme)
end

return module
