local notify = require("notify")

local module = {}
module.opts = {background_colour = "#000000"}
function module.setup()
    notify.setup(module.opts)
end
return module
