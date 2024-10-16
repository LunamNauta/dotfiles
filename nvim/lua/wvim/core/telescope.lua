local telescope = require("telescope")
local telescope_actions = require("telescope.actions")

local module = {}
module.opts = {
    extensions = {
        file_browser = {
            hijack_netrw = true,
            mappings = {
                ["i"] = {
                    ["<ESC>"] = telescope_actions.close
                }
            }
        },
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true
        }
    }
}
function module.setup()
    telescope.setup(module.opts)
    telescope.load_extension("file_browser")
    telescope.load_extension("fzf")
end
return module
