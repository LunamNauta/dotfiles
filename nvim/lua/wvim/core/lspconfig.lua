local lspconfig = require("lspconfig")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local module = {}
module.opts = {}
function module.setup()
    local default_capabilities = cmp_nvim_lsp.default_capabilities()
    local default_handlers =  {
        ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"}),
        ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"}),
    }
    for _, v in ipairs(wvim.languages.mason_lspconfig) do
        local opts = vim.tbl_deep_extend("force", wvim.languages.mason_lspconfig_opts[v] or {}, {capabilities = default_capabilities, handlers = default_handlers})
        lspconfig[v].setup(opts)
    end
end
return module
