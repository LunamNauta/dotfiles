local treesitter = require("nvim-treesitter.configs")

local module = {}
module.opts = {
    ensure_installed = wvim.treesitter,
    highlight = {enable = true}
}
function module.setup()
    treesitter.setup(module.opts)
end
return module
