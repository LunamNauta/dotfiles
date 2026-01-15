return{{
    'neovim/nvim-lspconfig',
    dependencies = {'williamboman/mason.nvim'},
    config = function(_, _)
        local default_capabilities = require('blink.cmp').get_lsp_capabilities()
        local default_handlers = {
            ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = 'rounded'}),
            ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = 'rounded'}),
        }
        vim.diagnostic.config({virtual_text = false})
        for server, lang in pairs(Wvim.languages) do
            local opts = vim.tbl_deep_extend(
                "force",
                lang.opts or {},
                {
                    capabilities = default_capabilities,
                    handlers = default_handlers,
                }
            )

            -- New API (0.11+)
            vim.lsp.config(server, opts)
            vim.lsp.enable(server)
        end
    end
}}
