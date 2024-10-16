local noice = require("noice")

local module = {}
module.opts = {
	presets = {
		bottom_search = false,
		command_palette = {
			views = {
				cmdline_popup = {
					position = {
						row = "2",
						col = "50%"
					},
					size = {
						min_width = 60,
						width = "auto",
						height = "auto"
					}
				}
			}
		}
	}
}
function module.setup()
    noice.setup(module.opts)
end
return module
