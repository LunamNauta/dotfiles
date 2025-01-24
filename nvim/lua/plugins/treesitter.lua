return{{
    'nvim-treesitter/nvim-treesitter',
    opts = {
        ensure_installed = {},
        highlight = {enable = true}
    },
    config = function(_, opts)
        for _, v1 in pairs(Wvim.languages) do
            for _, v2 in pairs(v1.langs) do
                table.insert(opts.ensure_installed, v2)
            end
        end
        require('nvim-treesitter.configs').setup(opts)
    end
}}
