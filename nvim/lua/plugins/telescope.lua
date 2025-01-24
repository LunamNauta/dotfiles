return{{
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-telescope/telescope-file-browser.nvim',
        'nvim-telescope/telescope-fzf-native.nvim',
        'nvim-lua/plenary.nvim'
    },
    opts = {
        extensions = {
            file_browser = {hijack_netrw = true,},
            fzf = {fuzzy = true, override_generic_sorter = true, override_file_sorter = true}
        }
    },
    config = function(_, opts)
        opts.extensions.file_browser.mappings={["i"]={["<ESC>"] = require("telescope.actions").close}}
        require("telescope").setup(opts)
        require("telescope").load_extension("file_browser")
        require("telescope").load_extension("fzf")
    end
},
{
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make"
}}
