local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

local module = {}
module.mason_lspconfig = {}
module.mason_lspconfig.opts = {
    ensure_installed = wvim.languages.mason_lspconfig,
    highlight = {enable = true}
}
function module.setup()
    mason.setup()
    mason_lspconfig.setup(module.mason_lspconfig.opts)
end
return module
