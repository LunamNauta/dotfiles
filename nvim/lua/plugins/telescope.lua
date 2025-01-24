return{
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'telescope-fzf-native.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
            'nvim-lua/plenary.nvim'
        },
        opts = {
            extensions = {
                file_browser = {hijack_netrw = true},
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true
                }
            }
        },
        config = function(_, opts)
            local telescope_actions = require('telescope.actions')
            local telescope = require('telescope')
            opts.extensions.file_browser.mappings={['i']={['<ESC>'] = telescope_actions.close}}
            telescope.setup(opts)
            telescope.load_extension('file_browser')
            telescope.load_extension('fzf')
            vim.keymap.set("n", "<LEADER>ff", "<CMD>Telescope file_browser<CR>")
        end
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make'
    }
}
