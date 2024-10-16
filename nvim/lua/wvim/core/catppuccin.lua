local catppuccin = require("catppuccin")

local module = {}
module.opts = {
	flavour = "mocha",
	no_italic = true,
	no_bold = true,
	no_underline = false,
    transparent_background = true,
    term_colors = true,
    integrations = {
        native_lsp = {
            enabled = true
        },
        telescope = true,
        treesitter = true,
        barbar = true
    }
}
function module.setup()
    catppuccin.setup(module.opts)
end
return module
