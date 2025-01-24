return{{
    'nvim-treesitter/nvim-treesitter',
    opts = {ensure_installed = {}},
    config = function(_, opts)
        for _, v1 in ipairs(Wvim.languages) do
            for _, v2 in ipairs(v1.lang) do
                table.insert(opts.ensure_installed, v2)
            end
        end
        require("nvim-treesitter").setup(opts)
    end
}}
