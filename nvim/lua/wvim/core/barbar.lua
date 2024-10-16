local barbar = require("barbar")

local module = {}
module.opts = {
    animation = false,
    clickable = false,
    icons = {button = ""}
}
function module.setup()
    barbar.setup(module.opts)
end
return module
