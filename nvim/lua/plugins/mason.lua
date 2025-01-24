return{{
    'williamboman/mason.nvim',
    dependencies={'williamboman/mason-lspconfig.nvim'},
    opts = {
        mason = {},
        mason_lspconfig = {
            ensure_installed = {},
            highlight = {enable = true}
        }
    },
    config = function(_, opts)
        for k, _ in pairs(Wvim.languages) do
            table.insert(opts.mason_lspconfig.ensure_installed, k)
        end
        require("mason").setup(opts.mason)
        require("mason-lspconfig").setup(opts.mason_lspconfig)
    end
}}
